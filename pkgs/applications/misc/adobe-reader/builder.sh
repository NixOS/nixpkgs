source $stdenv/setup

echo "unpacking $src..."
tar xvfa $src

echo "unpacking reader..."
p=$out/libexec/adobe-reader
mkdir -p $out/libexec
tar xvf AdobeReader/COMMON.TAR -C $out
tar xvf AdobeReader/ILINXR.TAR -C $out
mv $out/Adobe/Reader9 $p
rmdir $out/Adobe

# Disable this plugin for now (it needs LDAP, and I'm too lazy to add it).
rm $p/Reader/intellinux/plug_ins/PPKLite.api

# More pointless files.
rm $p/bin/UNINSTALL

patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
    --set-rpath $libPath \
    $p/Reader/intellinux/bin/acroread

# The "xargs -r" is to shut up a warning when Mozilla can't be found.
substituteInPlace $p/bin/acroread \
    --replace /bin/pwd $(type -P pwd) \
    --replace /bin/ls $(type -P ls) \
    --replace xargs "xargs -r"

mkdir -p $out/bin
ln -s $p/bin/acroread $out/bin/acroread

mkdir -p $out/share/applications
mv $p/Resource/Support/AdobeReader.desktop $out/share/applications/
icon=$p/Resource/Icons/128x128/AdobeReader9.png
[ -e $icon ]
sed -i $out/share/applications/AdobeReader.desktop \
    -e "s|Icon=.*|Icon=$icon|"

# Not sure if this works.
mkdir -p $out/share/mimelnk/application
mv $p/Resource/Support/vnd*.desktop $out/share/mimelnk/application
