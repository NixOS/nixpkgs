source $stdenv/setup

size=$(($size * 1024 * 1024))

image=$out/image
ensureDir $out

echo "building image \`$fullName'"
echo "$name" > $out/name
echo "$fullName" > $out/full-name

echo "creating sparse file of $size bytes in $image..."
dd if=/dev/zero of=$image bs=1 seek=$((size - 1)) count=1

echo "creating e2fs file system in $image..."
$e2fsprogs/sbin/mke2fs -F $image

echo "initialising file system through UML..."
echo $PATH > path
echo $rpm > rpm
echo $sysvinit > sysvinit
echo $rpms > rpms
echo $postInstall > post-install
ln -s $worker $NIX_BUILD_TOP/worker # work around a stupid bug (no dots allowed in kernel arguments?)

# UML requires an existing $HOME.
mkdir dummy
export HOME=$(pwd)/dummy

# Run UML.
touch log
tail -n +0 -f log & # show UML output as it appears
tailPid=$!

linux ubd0=$image root=/dev/root rootflags=/ rootfstype=hostfs \
  init="$SHELL $NIX_BUILD_TOP/worker $NIX_BUILD_TOP" con=null || true
  
echo image is $image

sleep 1 # drain `tail', hacky
kill $!

if ! test -e success; then exit 1; fi
