. $stdenv/setup

header "downloading $out from $url"

curl --fail --location --max-redirs 20 "$url" > "$out"

stopNest
