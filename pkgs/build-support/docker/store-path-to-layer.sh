#!@shell@

set -eu

layerNumber=$1
shift

storePath="$1"
shift

layerPath="./layers/$layerNumber"
echo "Creating layer #$layerNumber for $storePath"

mkdir -p "$layerPath"

# Make sure /nix and /nix/store appear first in the archive.
# We create the directories here and use them because
# when there are other things being added to the
# nix store, tar could fail, saying,
# "tar: /nix/store: file changed as we read it"
mkdir -p nix/store
tar -cf "$layerPath/layer.tar"  \
    --mtime="@$SOURCE_DATE_EPOCH" \
    --owner=0 --group=0 \
    --transform='s,nix,/nix,' \
    nix

# We change into the /nix/store in order to avoid a similar
# "file changed as we read it" error as above. Namely,
# if we use the absolute path of /nix/store/123-pkg
# and something new is added to the nix store while tar
# is running, it will detect a change to /nix/store and
# fail. Instead, if we cd into the nix store and copy
# the relative nix store path, tar will ignore changes
# to /nix/store. In order to create the correct structure
# in the tar file, we transform the relative nix store
# path to the absolute store path.
n=$(basename "$storePath")
tar -C /nix/store -rpf "$layerPath/layer.tar" \
    --hard-dereference --sort=name \
    --mtime="@$SOURCE_DATE_EPOCH" \
    --owner=0 --group=0 \
    --transform="s,$n,/nix/store/$n," \
    $n

# Compute a checksum of the tarball.
tarhash=$(tarsum < $layerPath/layer.tar)

# Add a 'checksum' field to the JSON, with the value set to the
# checksum of the tarball.
cat ./generic.json | jshon -s "$tarhash" -i checksum > $layerPath/json

# Indicate to docker that we're using schema version 1.0.
echo -n "1.0" > $layerPath/VERSION
