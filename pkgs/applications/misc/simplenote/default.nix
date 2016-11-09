{ fetchurl, stdenv, lib, zlib, glib, alsaLib, dbus, gtk2, atk, pango, freetype, fontconfig
, libgnome_keyring3, gdk_pixbuf, gvfs, cairo, cups, expat, libgpgerror, nspr
, nss, xorg, libcap, systemd, libnotify ,libXScrnSaver, pkgs }:

 stdenv.mkDerivation rec {

  name = "simplenote-${pkgver}";
  pkgver = "1.0.6";

  src = fetchurl {
    url = "https://github.com/Automattic/simplenote-electron/releases/download/v${pkgver}/${name}.deb";
    md5 = "752fa5f16e22f3a8e5cc4a87195099de";
    name = "${name}.deb";
  };

  buildCommand = let

  packages = [
    stdenv.cc.cc zlib glib dbus gtk2 atk pango freetype libgnome_keyring3
    fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr nss
    xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
    xorg.libXcomposite xorg.libXi xorg.libXfixes xorg.libXrandr
    xorg.libXcursor libcap systemd libnotify libXScrnSaver pkgs.gnome3.gconf
  ];

  libPathNative = lib.makeLibraryPath packages;
  libPath64 = lib.makeSearchPathOutput "lib" "lib64" packages;
  libPath = "${libPathNative}:${libPath64}";

  in ''
    mkdir -p $out/bin/
    mkdir -p $out/usr
    ar p $src data.tar.gz | tar -C $out -xz ./usr
    substituteInPlace $out/usr/share/applications/simplenote.desktop \
      --replace /usr/share/simplenote $out/bin

    mv $out/usr/* $out/
    rm -r $out/usr/

    fixupPhase

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}:$out/share/simplenote" \
      $out/share/simplenote/simplenote

    ln -s $out/share/simplenote/simplenote $out/bin/simplenote
  '';

  meta = with stdenv.lib; {
    description = "The simplest way to keep notes.";
    homepage = https://github.com/Automattic/simplenote-electron;
    license = licenses.lgpl2;
    platforms = [ "x86_64-linux" ];
  };
}
