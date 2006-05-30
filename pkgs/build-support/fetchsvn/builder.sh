source $stdenv/setup

header "exporting $url (r$rev) into $out"

# Pipe the "p" character into Subversion to force it to accept the
# server's certificate.  This is perfectly safe: we don't care
# whether the server is being spoofed --- only the cryptographic
# hash of the output matters.
echo 'p' | svn export -r "$rev" "$url" $out

actual=$(nix-hash $out)
if test "$actual" != "$outputHash"; then
    echo "hash is $actual, expected $outputHash" >&2
    exit 1
fi

stopNest
