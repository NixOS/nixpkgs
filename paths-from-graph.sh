graph="$1"

while read storePath; do
    echo $storePath
    read deriver
    read count
    for ((i = 0; i < $count; i++)); do
        read ref
    done
done < $graph
