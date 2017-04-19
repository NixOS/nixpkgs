source "$stdenv/setup"

header "exporting \`$url' (revision $rev) into \`$out'"

# avoid creating a log file ~/.bzr.log,
# because nixbld user have no home
export BZR_LOG=/dev/null

# Perform a lightweight checkout so that we don't end up importing

# all the repository's history.
BZR_LOG=/dev/null bzr -Ossl.cert_reqs=none export -r "$rev" --format=dir "$out" "$url"

stopNest
