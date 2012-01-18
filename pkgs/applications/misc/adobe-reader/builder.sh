source $stdenv/setup

echo "unpacking $src..."
tar xvfa $src

mkdir -p $out/Adobe/Reader9

echo "unpacking reader..."
set +e
tar xvf AdobeReader/COMMON.TAR -C $out
tar xvf AdobeReader/ILINXR.TAR -C $out
set -e

# Disable this plugin for now (it needs LDAP, and I'm too lazy to add it).
rm $out/Adobe/Reader*/Reader/intellinux/plug_ins/PPKLite.api

patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
    --set-rpath $libPath \
    $out/Adobe/Reader*/Reader/intellinux/bin/acroread

# The "xargs -r" is to shut up a warning when Mozilla can't be found.
substituteInPlace $out/Adobe/Reader*/bin/acroread \
    --replace /bin/pwd $(type -P pwd) \
    --replace /bin/ls $(type -P ls) \
    --replace xargs "xargs -r"

mkdir -p $out/bin
ln -s $out/Adobe/Reader*/bin/acroread $out/bin/acroread
