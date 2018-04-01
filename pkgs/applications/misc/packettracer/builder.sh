# Adapted from <https://aur.archlinux.org/packages/packettracer/>

source $stdenv/setup

p=$out/opt/packettracer
mkdir -p $p

# XXX: when extracting some files we apparently lack permission? Why?
echo "unpacking $src..."
tar xvfa $src --directory $p > /dev/null || echo "some files could not be extracted, continuing..."

# Mime Info for PKA, PKT, PKZ
install -D -m644 "$p/bin/Cisco-pka.xml" "$out/usr/share/mime/packages/Ciso-pka.xml"
install -D -m644 "$p/bin/Cisco-pkt.xml" "$out/usr/share/mime/packages/Ciso-pkt.xml"
install -D -m644 "$p/bin/Cisco-pkz.xml" "$out/usr/share/mime/packages/Ciso-pkz.xml"

# Install Mimetype Icons
install -D -m644 "$p/art/pka.png" "$out/usr/share/icons/hicolor/48x48/mimetypes/application-x-pka.png"
install -D -m644 "$p/art/pkt.png" "$out/usr/share/icons/hicolor/48x48/mimetypes/application-x-pkt.png"
install -D -m644 "$p/art/pkz.png" "$out/usr/share/icons/hicolor/48x48/mimetypes/application-x-pkz.png"

# EULA
install -D -m644 "$p/eula.txt" "$out/usr/share/licenses/packettracer/eula.txt"

# Add environment variable
mkdir -p "$out/etc/profile.d"
echo "export PT_HOME=$p" > "$out/etc/profile.d/packettracer.sh"

# Remove unused files
rm -r $p/lib $p/install

# Patch binaries
_patchelf() {
    patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $1
}

echo "patching binaries..."
_patchelf $p/bin/PacketTracer7
_patchelf $p/bin/linguist
_patchelf $p/bin/meta
_patchelf $p/extensions/meta
# _patchelf $p/extensions/upnp/upnp # verified with hash?

# Symlink to /bin
mkdir -p "$out/bin"
ln -s "$p/bin/PacketTracer7" "$out/bin/PacketTracer7"
ln -s "$p/bin/linguist" "$out/bin/linguist"
ln -s "$p/bin/meta" "$out/bin/meta"

# Install desktop file
install -D -m644 "$p/bin/Cisco-PacketTracer.desktop" "$out/usr/share/applications/Cisco-PacketTracer.desktop"
sed "s#/opt/pt/#$out/#g" -i "$out/usr/share/applications/Cisco-PacketTracer.desktop"
rm "$p/bin/Cisco-PacketTracer.desktop"
