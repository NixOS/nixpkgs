source $stdenv/setup

# Curl flags to handle redirects, not use EPSV, handle cookies for
# servers to need them during redirects, and work on SSL without a
# certificate (this isn't a security problem because we check the
# cryptographic hash of the output anyway).

set -o noglob

# we handle retries manually, since curl does also retry on http 500
[ -z "$retryCount" ] && retryCount=2

curl="curl            \
 --location           \
 --max-redirs 20      \
 --retry 0            \
 --disable-epsv       \
 --cookie-jar cookies \
 --insecure           \
 --speed-time 5       \
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
        echo "fetchipfs: add $ipfs"
        tar --owner=root --group=root -cWf "source.tar" $(echo *)
        res=$(curl -X POST -# -F "file=@source.tar" "localhost:5001/api/v0/tar/add" | sed 's/.*"Hash":"\(.*\)".*/\1/')
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

if curl -X POST --retry 0 --head --silent "localhost:5001" > /dev/null; then
    curlexit=18;
    echo "fetchipfs: get $ipfs"
    api_path_tar="tar/cat?"
    api_path_get="get?archive=true&compress=false&"
    api_path="$api_path_tar"

    retry_step=0
    for (( loop_step = 1; ; loop_step++ )); do
        if (( $loop_step % 50 == 0 )); then
            # debug infinite loop: show progress every 50 steps
            echo "fetchipfs: loop step $loop_step"
        fi

        # keep this inside an if statement, since on failure it doesn't abort the script
        if http_code=$($curl -s -w "%{http_code}" -X POST -C - "http://localhost:5001/api/v0/${api_path}arg=$ipfs" --output "$ipfs.tar")
        then
            sleep 0.5 # WORKAROUND tar: time stamp is 0.2 s in the future https://github.com/ipfs/go-ipfs/issues/8406
            unpackFile "$ipfs.tar"
            rm "$ipfs.tar"
            if [[ "$api_path" == "$api_path_tar" ]]; then
                mkdir -p "$out"
                set +o noglob # enable glob
                set -o dotglob # also glob hidden files
                mv * "$out"
            else
                mv "$ipfs" "$out"
            fi
            finish
        else
            curlexit=$?

            if [[ $curlexit == 18 ]]; then
                # continue partial download (curl -C -)
                continue
            fi

            if [[ "$http_code" == 500 && "$api_path" == "$api_path_tar" ]]; then
                # change api method
                api_path="$api_path_get"
                continue
            fi

            retry_step=$(($retry_step + 1))
            if (( $retry_step > $retryCount )); then
                echo "fetchipfs: retry end"
                break
            fi

            echo "fetchipfs: retry $retry_step"
        fi
    done
fi

if test -n "$url"; then
    curlexit=18;
    echo "fetchipfs: download $url"
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
