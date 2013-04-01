source "$stdenv/setup"

header "exporting \`$url' (revision $revision) into \`$out'"

# Perform a lightweight checkout so that we don't end up importing
# all the repository's history.
bzr -Ossl.cert_reqs=none export -r "$revision" --format=dir "$out" "$url"

stopNest
