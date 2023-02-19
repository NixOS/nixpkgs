source $stdenv/setup

aria_home=$TMP
mkdir -p $aria_home/.aria2

# declare -a requestedFiles=(...)
source $requestedFilesArrayPath

if [ -n "$ariaCommandFile" ]; then
    source $ariaCommandFile
fi

if ! type ariaCommand >/dev/null 2>&1; then
    ariaCommand() {
        aria2c "$@"
    }
fi

echo
echo tracker list:
cat $trackerslistFile | grep .
echo

if [ -n "$extraTrackerslistFile" ]; then
    echo
    echo extra tracker list:
    cat $extraTrackerslistFile | grep .
fi

debug=false
#debug=true
if (( NIX_DEBUG >= 1 )); then debug=true; fi



# create config

cat >$aria_home/.aria2/aria2.conf <<EOF
bt-tracker=$(cat $trackerslistFile $extraTrackerslistFile | xargs printf "%s,")
seed-time=0
ca-certificate=$caCertificate
listen-port=$listenPort
dht-listen-port=$dhtListenPort
enable-dht=$(
    # TODO better
    if [ "$enableDHT" = 1 ]; then echo true; else echo false; fi
)
check-integrity=true
file-allocation=$fileAllocation
summary-interval=$summaryInterval
download-result=hide
$(if ! $doUpload; then
    # FIXME disable seeding completely
    # this will limit upload to 1 byte/sec
    # https://askubuntu.com/questions/989780/prevent-aria2c-from-uploading-torrent-files
    echo max-upload-limit=1
fi)
EOF



# fetch metadata

echo fetching metadata
HOME=$aria_home ariaCommand "magnet:?xt=urn:btih:$btih" --bt-save-metadata --bt-metadata-only

torrentfile=$PWD/$btih.torrent

echo
echo torrent metadata:
for key in name comment source created-by creation-date size piece-size piece-count http-seeds web-seeds private protocol; do
    value="$(torrenttools show $key $torrentfile)"
    echo "$key: ${value@Q}"
done
# too verbose: files, trackers
#torrenttools info $torrentfile
echo



# fetch files

ariaOptions=()

declare -a allFiles="($(torrenttools info --raw $torrentfile | jq -r '.info.files | (.[].path | join("/")) | @sh'))"

echo all files in torrent:
n=1
for file in "${allFiles[@]}"; do
    echo "file $n: ${file@Q}"
    n=$((n + 1))
done
echo

if (( ${#requestedFiles[@]} > ${#allFiles[@]} )); then
    echo error: requested more files than files in torrent. requested ${#requestedFiles[@]} vs torrent ${#allFiles[@]}
    exit 1
fi

fileNumbers=()
if [[ ${#allFiles[@]} != 1 ]] && [[ ${#requestedFiles[@]} != 0 ]]; then
    echo selected files for download:
    for file in "${requestedFiles[@]}"; do
        found=false
        n=1
        for f in "${allFiles[@]}"; do
            if [[ "$file" != "$f" ]]; then
                n=$((n + 1))
                continue
            fi
            echo "file $n: ${file@Q}"
            fileNumbers+=($n)
            found=true
            break
        done
        if ! $found; then
            echo
            echo error: file not found in torrent: ${file@Q}
            exit 1
        fi
    done
    echo
    if [[ ${#fileNumbers[@]} == 0 ]]; then
        echo error: not found requested files
        exit 1
    fi
    ariaOptions+=(--select-file=$(printf "%s," ${fileNumbers[@]}))
fi

if [[ ${#allFiles[@]} == 1 ]] || [[ ${#requestedFiles[@]} == 1 ]]; then
    echo fetching a single file to $out
    if [[ ${#allFiles[@]} == 1 ]]; then
        n=1
    else
        n=${fileNumbers[0]}
    fi
    ariaOptions+=("--dir=$NIX_STORE")
    ariaOptions+=("--index-out=$n=$(basename $out)")
else
    echo fetching multiple files to $out
    # TODO wording. better than "multiple". all files? N files?
    # workaround: strip first component of all paths
    # aria has no option to strip the root folder
    # we would need something like: tar --strip-components=1
    if true; then
        # download to symlinked root folder
        mkdir $out
        ln -s $out "$(torrenttools show name $torrentfile)"
    else
        # rename all files
        ariaOptions+=("--dir=$out")
        n=1
        for file in "${allFiles[@]}"; do
            ariaOptions+=("--index-out=$n=$file")
            n=$((n + 1))
        done
    fi
fi
echo

if $debug; then
    echo ariaOptions:
    for option in "${ariaOptions[@]}"; do
        echo option: $option
    done
    echo
fi

HOME=$aria_home ariaCommand $torrentfile "${ariaOptions[@]}"



if [ "$fileAllocation" != "none" ]; then
    # workaround for bug in file-allocation != none
    # aria will create too many files
    # because one torrent chunk can span across multiple files
    # https://github.com/aria2/aria2/issues/2032
    if (( 1 < ${#requestedFiles[@]} )) && (( ${#requestedFiles[@]} < ${#allFiles[@]} )); then
        # partial download of 2 or more files
        cd $out
        downloadedFiles=()
        while read file; do
            downloadedFiles+=("$file")
        done < <(find . -not -type d -printf "%P\n")
        if (( ${#requestedFiles[@]} < ${#downloadedFiles[@]} )); then
            if $debug; then
                echo "removing unwanted files (workaround for bug: aria2 creates empty files)"
            fi
            for file in "${downloadedFiles[@]}"; do
                requested=false
                for f in "${requestedFiles[@]}"; do
                    if [[ "$f" == "$file" ]]; then
                        requested=true
                        break
                    fi
                done
                if ! $requested; then
                    if $debug; then
                        rm -v "$file"
                    else
                        rm "$file"
                    fi
                fi
            done
        fi
    fi
fi

if $debug; then
    echo result:
    (cd $out && find . -printf "%P\n")
fi
