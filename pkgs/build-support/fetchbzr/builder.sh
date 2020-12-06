source "$stdenv/setup"

header "exporting \`$url' (revision $rev) into \`$out'"

# Perform a lightweight checkout so that we don't end up importing
# all the repository's history.
BZR_LOG=/dev/null bzr -Ossl.cert_reqs=none export -r "$rev" --format=dir "$out" "$url"

stopNest
