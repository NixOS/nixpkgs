{ stdenv, fetchurl, buildEnv, gtk2, glib, gdk_pixbuf, alsaLib, nss, nspr, gconf
, cups, libgcrypt_1_5, systemd, makeWrapper, dbus }:
with stdenv.lib;

let
  bracketsLibs = makeLibraryPath [
    gtk2 glib gdk_pixbuf stdenv.cc.cc.lib alsaLib nss nspr gconf cups libgcrypt_1_5 dbus systemd
  ];
in
stdenv.mkDerivation rec {
  name = "brackets-${version}";
  version = "1.9";

  src = fetchurl {
    url = "https://github.com/adobe/brackets/releases/download/release-${version}/Brackets.Release.${version}.64-bit.deb";
    sha256 = "0c4l2rr0853xd21kw8hhxlmrx8mqwb7iqa2k24zvwyjp4nnwkgbp";
    name = "${name}.deb";
  };

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out
    ar p $src data.tar.xz | tar -C $out -xJ

    mv $out/usr/* $out/
    rmdir $out/usr
    ln -sf $out/opt/brackets/brackets $out/bin/brackets

    ln -s ${systemd.lib}/lib/libudev.so.1 $out/opt/brackets/lib/libudev.so.0

    substituteInPlace $out/opt/brackets/brackets.desktop \
      --replace "Exec=/opt/brackets/brackets" "Exec=brackets"
    mkdir -p $out/share/applications
    ln -s $out/opt/brackets/brackets.desktop $out/share/applications/
  '';

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${bracketsLibs}:$out/opt/brackets/lib" \
      $out/opt/brackets/Brackets

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${bracketsLibs}" \
      $out/opt/brackets/Brackets-node

    patchelf --set-rpath "${bracketsLibs}" \
      $out/opt/brackets/lib/libcef.so
  '';

  meta = {
    description = "An open source code editor for the web, written in JavaScript, HTML and CSS";
    homepage = http://brackets.io/;
    license = licenses.mit;
    maintainers = [ maintainers.matejc ];
    platforms = [ "x86_64-linux" ];
  };
}
