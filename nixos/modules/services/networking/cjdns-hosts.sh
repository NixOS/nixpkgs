pubs=($pubs)
hosts=($hosts)

lines="''\n"
for ((i = 0; i < ${#pubs[*]}; i++)); do
    addr=$($cjdns/bin/publictoip6 ${pubs[i]})
    lines="${lines}$addr ${hosts[i]}\n"
done
lines="${lines}''"

echo -ne $lines > $out
