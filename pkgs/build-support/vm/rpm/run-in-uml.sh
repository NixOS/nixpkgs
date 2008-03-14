export > initial-env-vars

source $stdenv/setup

ensureDir $out/nix-support
echo "$system" > $out/nix-support/system
cat $image/name > $out/nix-support/name
cat $image/full-name > $out/nix-support/full-name

echo $PATH > path
ln -s $boot $NIX_BUILD_TOP/worker # work around a stupid bug (no dots allowed in kernel arguments?)

# UML requires an existing $HOME.
mkdir dummy
export HOME=$(pwd)/dummy

# Run UML.
startLog "uml-run"
touch log
tail -n +0 -f log & # show UML output as it appears
tailPid=$!

echo "running UML using image $image/image ($(cat $image/full-name))"
linux mem=384M ubd0=cow,$image/image root=/dev/root rootflags=/ rootfstype=hostfs \
  init="$SHELL $NIX_BUILD_TOP/worker $NIX_BUILD_TOP" con=null || true
echo "UML finished"

sleep 1 # drain `tail', hacky
kill $!
stopLog

if ! test -e success; then
    echo "UML build script failed"
    exit 1
fi
