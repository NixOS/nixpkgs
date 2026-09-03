source "$NIX_ATTRS_SH_FILE"

# This file will bring variables of the form "_mirror_<mirrorname>" into scope.
# DO NOT USE the "_mirror" prefix for variables in this script to avoid
# accidentally clobbering them.
source "$mirrorsListFile"

# Normalize `curlOpts` as a string.
# If defined as a list (deprecated), it would be a bash array.
if [[ "$(declare -p curlOpts 2&>/dev/null || true)" =~ ^"declare -a" ]]; then
    unset _temp
    _temp="${curlOpts[*]}"
    unset curlOpts
    curlOpts=$_temp
    unset _temp
fi

curlVersion=$(curl -V | head -1 | cut -d' ' -f2)

# Curl flags to handle redirects, not use EPSV, handle cookies for
# servers to need them during redirects, and work on SSL without a
# certificate (this isn't a security problem because we check the
# cryptographic hash of the output anyway).
curl=(
    curl
    --location
    --max-redirs 20
    --retry 3
    --retry-all-errors
    --continue-at -
    --disable-epsv
    --cookie-jar cookies
    --user-agent "curl/$curlVersion Nixpkgs/$nixpkgsVersion"
)

if ! [ -f "$SSL_CERT_FILE" ]; then
    curl+=(--insecure)
fi

# NOTE:
# `netrcPhase` should not attempt to access builder.sh implementation details (e.g., the `${curl[@]}` array),
# The implementation detail could change in any Nixpkgs revision, including backports.
if [[ -n "${netrcPhase-}" ]]; then
    runPhase netrcPhase
    curl+=(--netrc-file "$PWD/netrc")
fi

curl+=("${curlOptsList[@]}")
concatTo curl curlOpts NIX_CURL_FLAGS

downloadedFile="$out"
if [ -n "$downloadToTemp" ]; then downloadedFile="$TMPDIR/file"; fi

tryDownload() {
    local url="$1"
    local target="$2"
    echo
    echo "trying $url"
    local curlexit=18;

    success=

    # if we get error code 18, resume partial download
    while [ "$curlexit" -eq 18 ]; do
       # keep this inside an if statement, since on failure it doesn't abort the script
       if "${curl[@]}" -C - --fail "$url" --output "$target" 2> >(tr '\r' '\n'); then
          success=1
          break
       else
          curlexit=$?;
       fi
    done
}


finish() {
    local skipPostFetch="$1"

    set +o noglob

    if [[ "$executable" == "1" ]]; then
      chmod +x "$downloadedFile"
    fi

    if [ -z "$skipPostFetch" ]; then
        runHook postFetch
    fi

    exit 0
}


tryHashedMirrors() {
    # The hashed mirrors are stored in the mirrorsListFile,
    # so we have to use the "_mirror_" prefix, the same as for any other mirror
    if test -n "$NIX_HASHED_MIRRORS"; then
        IFS=' ' read -r -a _mirror_hashedMirrors <<< "$NIX_HASHED_MIRRORS"
    fi

    local mirror
    for mirror in "${_mirror_hashedMirrors[@]}"; do
        local url="$mirror/$outputHashAlgo/$outputHash"
        if "${curl[@]}" --retry 0 --connect-timeout "${NIX_CONNECT_TIMEOUT:-15}" \
            --fail --silent --show-error --head "$url" \
            --write-out "%{http_code}" --output /dev/null > code 2> log; then
            # Directly download to $out, because postFetch doesn't need to run,
            # since hashed mirrors provide pre-built derivation outputs.
            tryDownload "$url" "$out"

            # We skip postFetch here, because hashed-mirrors are
            # already content addressed. So if $outputHash is in the
            # hashed-mirror, changes from ‘postFetch’ would already be
            # made. So, running postFetch will end up applying the
            # change /again/, which we don’t want.
            if test -n "$success"; then finish skipPostFetch; fi
        else
            # Be quiet about 404 errors, which we interpret as the file
            # not being present on this particular mirror.
            if test "$(cat code)" != 404; then
                echo "error checking the existence of $url:"
                cat log
            fi
        fi
    done
}


# URL list may contain ?. No glob expansion for that, please
set -o noglob

resolvedUrls=()

_resolveUrls() {
    local url
    for url in "${urls[@]}"; do
        # Direct URL: just add it and we're done
        if test "${url:0:9}" != "mirror://"; then
            resolvedUrls+=("${url}")
            continue
        fi

        # Try to get appropriate mirrors via the sourced mirrorsListFile
        # Start by looking for mirror:// and splitting everything after that
        # into a site and a path - the site part should lead us to an array
        # with the URLs
        if ! [[ "$url" =~ ^mirror://([^/ ]+)[/]([^ ]+)$ ]]; then
          echo "error: fetchurl: $name: invalid mirror:// URL format: $url" >&2
          exit 1
        fi
        local site="${BASH_REMATCH[1]}"
        local filePath="${BASH_REMATCH[2]}"

        # The name of the array containing mirrors for site
        local varName="_mirror_${site}"
        # Needed to iterate over the array using an indirect reference
        local arrName="${varName}[@]"
        if ! test -v "${arrName}"; then
            echo "warning: unknown mirror:// site \`${site}'"
            continue
        fi

        local mirrorUrls
        mirrorUrls=("${!arrName}")

        # Allow command-line override by setting NIX_MIRRORS_$site.
        # This is a string we should split, not an array,
        # so we don't need arrName here.
        varName="NIX_MIRRORS_${site}"
        if test -n "${!varName}"; then
            IFS=' ' read -r -a mirrorUrls <<< "${!varName}"
        fi

        local mirrorUrl
        for mirrorUrl in "${mirrorUrls[@]}"; do
            resolvedUrls+=("${mirrorUrl}${filePath}");
        done
    done
}

_resolveUrls

# Restore globbing settings
set +o noglob

if test -n "$showURLs"; then
    echo "${resolvedUrls[*]}" > "$out"
    exit 0
fi

if test -n "$preferHashedMirrors"; then
    tryHashedMirrors
fi

# URL list may contain ?. No glob expansion for that, please
set -o noglob

success=
for url in "${resolvedUrls[@]}"; do
    if [ -z "$postFetch" ]; then
       case "$url" in
           https://github.com/*/archive/*)
               echo "warning: archives from GitHub revisions should use fetchFromGitHub"
               ;;
           https://gitlab.com/*/-/archive/*)
               echo "warning: archives from GitLab revisions should use fetchFromGitLab"
               ;;
           *)
               ;;
       esac
    fi
    tryDownload "$url" "$downloadedFile"
    if test -n "$success"; then finish; fi
done

# Restore globbing settings
set +o noglob

if test -z "$preferHashedMirrors"; then
    tryHashedMirrors
fi


echo "error: cannot download $name from any mirror"
exit 1
