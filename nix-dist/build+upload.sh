#! /bin/sh

url="https://svn.cs.uu.nl:12443/repos/trace/nix/trunk/"

curl="curl --fail --silent --show-error"
# auth-info file should have format `username:password'.
if ! auth_info=$(cat auth-info); then
    echo "cannot get authentication info"
    exit 1
fi
curl_up="$curl --user $auth_info"

rev=$(svn log --quiet --non-interactive "$url" \
    | grep '^r' \
    | sed "s/r\([0-9]*\).*$/\1/" \
    | head -n 1)
if test -z "$rev"; then
    echo "cannot fetch head revision number"
    exit 1
fi

echo "building revision $rev of $url"

# !!! race
echo $rev > head-revision.nix

if ! storeexprs=($(nix-instantiate -vv do-it.nix)); then exit 1; fi

srcexpr=${storeexprs[0]}
testexpr=${storeexprs[1]}
rpmexpr=${storeexprs[2]}

if ! outpath=$(nix-store -vvvv -qnf "$srcexpr"); then exit 1; fi

uploader="http://catamaran.labs.cs.uu.nl/~eelco/cgi-bin/create-dist.pl"

# Extract the name of the release.
relname=$((cd $outpath && echo nix-*.tar.bz2) | sed -e s/.tar.bz2//)
echo "release is $relname"

# If it already exists on the server, quit.
if ! exists=$($curl_up $uploader/exists/$relname); then
    echo "cannot check for existence of $relname on the server"
    exit 1
fi
if test "$exists" = "yes"; then
    echo "server already has release $relname"
    exit 0
fi

# Create an upload session on the server.
if ! sessionname=$($curl_up $uploader/create/$relname); then
    echo "cannot create upload session"
    exit 1
fi
echo "session name is $sessionname"

# Upload the source distribution and the manual.
$curl_up -T "$outpath"/nix-*.tar.bz2 "$uploader/upload/$sessionname/" || exit 1
$curl_up -T "$outpath"/manual.tar.bz2 "$uploader/upload-tar/$sessionname" || exit 1

# Perform a test build.
#if ! nix-store -vvvv -r "$testexpr" > /dev/null; then exit 1; fi

# Perform an RPM build, and upload the RPM to the server.
if ! rpmpath=$(nix-store -vvvv -qnf "$rpmexpr"); then exit 1; fi
$curl_up -T "$rpmpath"/nix-*.rpm "$uploader/upload/$sessionname/" || exit 1

# Finish the upload session.
$curl_up "$uploader/finish/$sessionname" || exit 1

# Publish the release on the Wiki.
# !!! create /tmp file
echo -n $relname > relname
$curl_up -T relname "$uploader/put/head-revision" || exit 1
rm -f $relname

# Force a refresh of the Wiki.
$curl 'http://www.cs.uu.nl/groups/ST/twiki/bin/fresh/Trace/NixDeploymentSystem' > /dev/null || exit 1
