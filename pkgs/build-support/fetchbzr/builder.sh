source "$stdenv/setup"

header "exporting \`$url' (revision $revision) into \`$out'"

# Perform a lightweight checkout so that we don't end up importing
# all the repository's history.
bzr checkout --lightweight "$url" -r "$revision" "$out"

stopNest
