if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

source $mirrorsFile

curlVersion=$(curl -V | head -1 | cut -d' ' -f2)

atoi() {
    printf '%d' "'$1"
}

# calculate a semi-unique activity ID from $out
actionId=65536
digit=0
while read -n1 char; do
    digit=$((digit + 1))
    actionId=$((actionId + $(atoi "$char") * digit))
done <<<"$out"

traceFile="curl.trace"
mkfifo "$traceFile"

startActivity() {
    # force-recreate the activity
    echo '@nix { "action": "stop", "id": '$actionId' }' >&$NIX_LOG_FD
    echo '@nix { "action": "start", "id": '$actionId', "type": 101, "level": 3, "text": "'$1'", "fields": [0,0,0,0] }' >&$NIX_LOG_FD
}

sendProgressToNix() {
    echo '@nix { "action": "result", "type": 105, "id": '$actionId', "fields": [ '$1', '$2', 0, 0 ] }' >&$NIX_LOG_FD
}

# background job that parses the trace FIFO
(
    bytesExpected=0;
    bytesRead=0;
    tail -f $traceFile | while read line; do
        if [[ "$line" = 0000:\ [Cc]ontent-[Ll]ength:* ]]; then
            bytesExpected="${line#0000: [Cc]ontent-[Ll]ength: }"
            sendProgressToNix "$bytesRead" "$bytesExpected"
        elif [[ "$line" = \<=\ Recv\ data,* ]]; then
            var1="${line#"<= Recv data, "}"
            var2="${var1%\ bytes*}"
            bytesRead=$((bytesRead + var2))
            sendProgressToNix "$bytesRead" "$bytesExpected"
        fi
    done
) &

# Curl flags to handle redirects, not use EPSV, handle cookies for
# servers to need them during redirects, and work on SSL without a
# certificate (this isn't a security problem because we check the
# cryptographic hash of the output anyway).
curl=(
    curl
    --location
    --max-redirs 20
    --retry 3
    --disable-epsv
    --cookie-jar cookies
    --no-progress-meter
    --trace-ascii "$traceFile"
    --user-agent "curl/$curlVersion Nixpkgs/$nixpkgsVersion"
)

if ! [ -f "$SSL_CERT_FILE" ]; then
    curl+=(--insecure)
fi

eval "curl+=($curlOptsList)"

curl+=(
    $curlOpts
    $NIX_CURL_FLAGS
)

downloadedFile="$out"
if [ -n "$downloadToTemp" ]; then downloadedFile="$TMPDIR/file"; fi


tryDownload() {
    local url="$1"
    echo
    header "trying $url"
    startActivity "downloading '$name' from '$url'"
    local curlexit=18;

    success=

    # if we get error code 18, resume partial download
    while [ $curlexit -eq 18 ]; do
       # keep this inside an if statement, since on failure it doesn't abort the script
       if "${curl[@]}" -C - --fail "$url" --output "$downloadedFile"; then
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

    if [[ $executable == "1" ]]; then
      chmod +x $downloadedFile
    fi

    if [ -z "$skipPostFetch" ]; then
        runHook postFetch
    fi

    exit 0
}


tryHashedMirrors() {
    if test -n "$NIX_HASHED_MIRRORS"; then
        hashedMirrors="$NIX_HASHED_MIRRORS"
    fi

    for mirror in $hashedMirrors; do
        url="$mirror/$outputHashAlgo/$outputHash"
        if "${curl[@]}" --retry 0 --connect-timeout "${NIX_CONNECT_TIMEOUT:-15}" \
            --fail --silent --show-error --head "$url" \
            --write-out "%{http_code}" --output /dev/null > code 2> log; then
            tryDownload "$url"

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

urls2=
for url in $urls; do
    if test "${url:0:9}" != "mirror://"; then
        urls2="$urls2 $url"
    else
        url2="${url:9}"; echo "${url2/\// }" > split; read site fileName < split
        #varName="mirror_$site"
        varName="$site" # !!! danger of name clash, fix this
        if test -z "${!varName}"; then
            echo "warning: unknown mirror:// site \`$site'"
        else
            mirrors=${!varName}

            # Allow command-line override by setting NIX_MIRRORS_$site.
            varName="NIX_MIRRORS_$site"
            if test -n "${!varName}"; then mirrors="${!varName}"; fi

            for url3 in $mirrors; do
                urls2="$urls2 $url3$fileName";
            done
        fi
    fi
done
urls="$urls2"

# Restore globbing settings
set +o noglob

if test -n "$showURLs"; then
    echo "$urls" > $out
    exit 0
fi

if test -n "$preferHashedMirrors"; then
    tryHashedMirrors
fi

# URL list may contain ?. No glob expansion for that, please
set -o noglob

success=
for url in $urls; do
    if [ -z "$postFetch" ]; then
       case "$url" in
           https://github.com/*/archive/*)
               echo "warning: archives from GitHub revisions should use fetchFromGitHub"
               ;;
           https://gitlab.com/*/-/archive/*)
               echo "warning: archives from GitLab revisions should use fetchFromGitLab"
               ;;
       esac
    fi
    tryDownload "$url"
    if test -n "$success"; then finish; fi
done

# Restore globbing settings
set +o noglob

if test -z "$preferHashedMirrors"; then
    tryHashedMirrors
fi


echo "error: cannot download $name from any mirror"
exit 1
