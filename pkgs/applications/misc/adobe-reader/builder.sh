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

mkdir -p $out/share/applications
mv $out/Adobe/Reader9/Resource/Support/AdobeReader.desktop $out/share/applications/
sed -i $out/share/applications/AdobeReader.desktop \
    -e "s|Icon=.*|Icon=$out/Adobe/Reader9/Resource/Icons/128x128/AdobeReader9.png|"

# Not sure if this works.
mkdir -p $out/share/mimelnk/application
mv $out/Adobe/Reader9/Resource/Support/vnd*.desktop $out/share/mimelnk/application
