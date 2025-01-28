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
    runHook postFetch
    set +o noglob
    exit 0
}

ipfs_add() {
    if curl --retry 0 --head --silent "localhost:5001" > /dev/null; then
        echo "[0m[01;36m=IPFS=[0m add $ipfs"
        tar --owner=root --group=root -cWf "source.tar" $(echo *)
        res=$(curl -# -F "file=@source.tar" "localhost:5001/api/v0/tar/add" | sed 's/.*"Hash":"\(.*\)".*/\1/')
        if [ $ipfs != $res ]; then
            echo "\`ipfs tar add' results in $res when $ipfs is expected"
            exit 1
        fi
        rm "source.tar"
    fi
}

echo

mkdir download
cd download

if curl --retry 0 --head --silent "localhost:5001" > /dev/null; then
    curlexit=18;
    echo "[0m[01;36m=IPFS=[0m get $ipfs"
    # if we get error code 18, resume partial download
    while [ $curlexit -eq 18 ]; do
        # keep this inside an if statement, since on failure it doesn't abort the script
        if $curl -C - "http://localhost:5001/api/v0/tar/cat?arg=$ipfs" --output "$ipfs.tar"; then
            unpackFile "$ipfs.tar"
            rm "$ipfs.tar"
            set +o noglob
            mv $(echo *) "$out"
            finish
        else
            curlexit=$?;
        fi
    done
fi

if test -n "$url"; then
    curlexit=18;
    echo "Downloading $url"
    while [ $curlexit -eq 18 ]; do
        # keep this inside an if statement, since on failure it doesn't abort the script
        if $curl "$url" -O; then
            set +o noglob
            tmpfile=$(echo *)
            unpackFile $tmpfile
            rm $tmpfile
            ipfs_add
            mv $(echo *) "$out"
            finish
        else
            curlexit=$?;
        fi
    done
fi

echo "[01;31merror:[0m cannot download $ipfs from ipfs or the given url"
echo
set +o noglob
exit 1
