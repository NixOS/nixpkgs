#! /bin/sh

url="https://svn.cs.uu.nl:12443/repos/trace/nix/trunk/"

if ! rev=$(curl --silent -k https://svn.cs.uu.nl:12443/repos/trace/nix/trunk/ \
 | grep '<h2>Revision' \
 | sed 's/.*Revision \(.*\):.*/\1/'); \
 then exit 1; fi

echo $rev > head-revision.nix

if ! storeexpr=$(nix-instantiate -vvv do-it.nix); then exit 1; fi

if ! nix-store -vvvv -r "$storeexpr" > /dev/null; then exit 1; fi

if ! outpath=$(nix-store -qn "$storeexpr"); then exit 1; fi

uploader="http://losser.st-lab.cs.uu.nl/~eelco/cgi-bin/upload.pl/"

curl --silent -T "$outpath/manual.html" "$uploader" || exit 1
curl --silent -T "$outpath"/nix-*.tar.bz2 "$uploader" || exit 1
