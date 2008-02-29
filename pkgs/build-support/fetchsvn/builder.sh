source $stdenv/setup

header "exporting $url (r$rev) into $out"

if test "$sshSupport"; then
    export SVN_SSH="$openssh/bin/ssh"
fi

# Pipe the "p" character into Subversion to force it to accept the
# server's certificate.  This is perfectly safe: we don't care
# whether the server is being spoofed --- only the cryptographic
# hash of the output matters.
echo 'p' | svn export -r "$rev" "$url" $out

stopNest
