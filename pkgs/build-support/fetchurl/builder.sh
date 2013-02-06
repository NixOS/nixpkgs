source $stdenv/setup

source $mirrorsFile


# Curl flags to handle redirects, not use EPSV, handle cookies for
# servers to need them during redirects, and work on SSL without a
# certificate (this isn't a security problem because we check the
# cryptographic hash of the output anyway). 
curl="curl \
 --location --max-redirs 20 \
 --retry 3
 --disable-epsv \
 --cookie-jar cookies \
 --insecure \
 $NIX_CURL_FLAGS"


tryDownload() {
    local url="$1"
    echo
    header "trying $url"
    success=
    if $curl --fail "$url" --output "$out"; then
        success=1
    fi
    stopNest
}


finish() {
    stopNest
    exit 0
}


tryHashedMirrors() {
    if test -n "$NIX_HASHED_MIRRORS"; then
        hashedMirrors="$NIX_HASHED_MIRRORS"
    fi
    
    for mirror in $hashedMirrors; do
        url="$mirror/$outputHashAlgo/$outputHash"
        if $curl --fail --silent --show-error --head "$url" \
            --write-out "%{http_code}" --output /dev/null > code 2> log; then
            tryDownload "$url"
            if test -n "$success"; then finish; fi
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
            # Assume that SourceForge/GNU/kernel mirrors have better
            # bandwidth than nixos.org.
            preferHashedMirrors=

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
