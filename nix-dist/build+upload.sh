#! /bin/sh

url="https://svn.cs.uu.nl:12443/repos/trace/nix/trunk/"

rev=$(svn log --quiet --non-interactive "$url" \
    | grep '^r' \
    | sed "s/r\([0-9]*\).*$/\1/" \
    | head -n 1)
if test -z "$rev"; then
    echo "cannot fetch head revision number"
    exit 1
fi

echo "building revision $rev of $url"

echo $rev > head-revision.nix

if ! storeexprs=($(nix-instantiate -vvv do-it.nix)); then exit 1; fi

srcexpr=${storeexprs[0]}
testexpr=${storeexprs[1]}
rpmexpr=${storeexprs[2]}

if ! nix-store -vvvv -r "$srcexpr" > /dev/null; then exit 1; fi
if ! outpath=$(nix-store -qn "$srcexpr"); then exit 1; fi

uploader="http://losser.st-lab.cs.uu.nl/~eelco/cgi-bin/create-dist.pl"

# Extract the name of the release.
relname=$((cd $outpath && echo nix-*.tar.bz2) | sed -e s/.tar.bz2//)
echo "release is $relname"

# If it already exists on the server, quit.
exists=$(curl -f --silent $uploader/exists/$relname)
if test "$exists" = "yes"; then
    echo "server already has release $relname"
    exit 0
fi

# Create an upload session on the server.
if ! sessionname=$(curl -f --silent $uploader/create/$relname); then
    echo "cannot create upload session"
    exit 1
fi
echo "session name is $sessionname"

# Upload the source distribution and the manual.
curl -f --silent -T "$outpath"/nix-*.tar.bz2 "$uploader/upload/$sessionname/" || exit 1
curl -f --silent -T "$outpath"/manual.tar.bz2 "$uploader/upload-tar/$sessionname" || exit 1

# Perform a test build.
#if ! nix-store -vvvv -r "$testexpr" > /dev/null; then exit 1; fi

# Perform an RPM build, and upload the RPM to the server.
if ! nix-store -vvvv -r "$rpmexpr" > /dev/null; then exit 1; fi
if ! rpmpath=$(nix-store -qn "$rpmexpr"); then exit 1; fi
curl -f --silent -T "$rpmpath"/nix-*.rpm "$uploader/upload/$sessionname/" || exit 1

# Finish the upload session.
curl -f --silent "$uploader/finish/$sessionname" || exit 1
