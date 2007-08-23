source $stdenv/setup

header "downloading file $name with $outputHashAlgo hash $outputHash..."

# Curl flags to handle redirects, not use EPSV, handle cookies for
# servers to need them during redirects, and work on SSL without a
# certificate (this isn't a security problem because we check the
# cryptographic hash of the output anyway). 
curl="curl \
 --location --max-redirs 20 \
 --disable-epsv \
 --cookie-jar cookies \
 --insecure"


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
    # On old versions of Nix, verify the hash of the output.  On newer
    # versions, Nix verifies the hash itself.
    if test "$NIX_OUTPUT_CHECKED" != "1"; then
        if test "$outputHashAlgo" != "md5"; then
            echo "hashes other than md5 are unsupported in Nix <= 0.7, upgrade to Nix 0.8"
            exit 1
        fi
        actual=$(md5sum -b "$out" | cut -c1-32)
        if test "$actual" != "$id"; then
            echo "hash is $actual, expected $id"
            exit 1
        fi
    fi

    stopNest
    exit 0
}


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


success=
for url in $urls; do
    tryDownload "$url"
    if test -n "$success"; then finish; fi
done


echo "error: cannot download $name from any mirror"
exit 1
