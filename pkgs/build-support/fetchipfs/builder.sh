source $stdenv/setup

# Curl flags to handle redirects, not use EPSV, handle cookies for
# servers to need them during redirects, and work on SSL without a
# certificate (this isn't a security problem because we check the
# cryptographic hash of the output anyway).

set -o noglob

curl="curl            \
 --location           \
 --max-redirs 20      \
 --retry 2            \
 --disable-epsv       \
 --cookie-jar cookies \
 --insecure           \
 --speed-time 5       \
 -#                   \
 --fail               \
 $curlOpts            \
 $NIX_CURL_FLAGS"

finish() {
    find "$out" -type f -exec chmod 644 {} \;
    for exes in $execs; do
        chmod +x "$out/$exes"
    done
    runHook postFetch
    set +o noglob
    exit 0
}

echo
echo -n "[0m[01;36m=IPFS=[0m get"

if test -d "/ipfs/$ipfs"; then
    echo " /ipfs/$ipfs"
    (timeout 5 cp -r "/ipfs/$ipfs" "$out" && finish)
    echo "Timed out"
fi

if $curl --retry 0 --head --silent "localhost:$port/ipfs/$ipfs" > /dev/null; then
    curlexit=18;
    echo " localhost:$port/ipfs/$ipfs"
    # if we get error code 18, resume partial download
    while [ $curlexit -eq 18 ]; do
        # keep this inside an if statement, since on failure it doesn't abort the script
        if $curl -C - --fail "http://localhost:$port/api/v0/get?arg=$ipfs&archive=true" --output "$ipfs.tar"; then
            unpackFile "$ipfs.tar"
            mv "$ipfs" "$out"
            finish
        else
            curlexit=$?;
        fi
    done
fi

if test -n "$url"; then
    curlexit=18;
    echo " $url"
    mkdir download
    cd download
    while [ $curlexit -eq 18 ]; do
        # keep this inside an if statement, since on failure it doesn't abort the script
        if $curl "$url" -O; then
            tmpfile=$(echo *)
            unpackFile $tmpfile
            rm $tmpfile
            mv $(echo *) "$out"
            finish
        else
            curlexit=$?;
        fi
    done
fi

curlexit=18;
echo " https://ipfs.io/ipfs/$ipfs"
while [ $curlexit -eq 18 ]; do
    # keep this inside an if statement, since on failure it doesn't abort the script
    if $curl "https://ipfs.io/api/v0/get?arg=$ipfs&archive=true&compress=true" --output "$ipfs.tar.gz"; then
        unpackFile "$ipfs.tar.gz"
        mv "$ipfs" "$out"
        finish
    else
        curlexit=$?;
    fi
done

echo "[01;31merror:[0m cannot download $ipfs from ipfs or the given url"
echo
set +o noglob
exit 1
