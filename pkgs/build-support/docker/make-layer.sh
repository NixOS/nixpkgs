#!/bin/sh

set -eu

configJsonFile=$1
shift
uid=$1
shift
gid=$1
shift
outPath=$1
shift

tar_args=""
if [ "$uid" != "-" ]; then
    tar_args="$tar_args --owner=$uid"
fi

if [ "$gid" != "-" ]; then
    tar_args="$tar_args --group=$gid"
fi

echo "Creating layer $outPath from $@"

mkdir -p "$outPath"
tar \
    --append \
    --preserve-permissions \
    --hard-dereference \
    --sort=name \
    --mtime="@$SOURCE_DATE_EPOCH" \
    $tar_args \
    --file "$outPath/layer.tar" \
    "$@"

# Compute a checksum of the tarball.
tarhash=$(tarsum < $outPath/layer.tar)

# Add a 'checksum' field to the JSON, with the value set to the
# checksum of the tarball.
cat "$configJsonFile" | jshon -s "$tarhash" -i checksum > $outPath/json

# Indicate to docker that we're using schema version 1.0.
echo -n "1.0" > $outPath/VERSION
