{ stdenv, lib, fetchurl, dpkg, atk, glib, pango, gdk-pixbuf, gnome2, gtk3, cairo
, freetype, fontconfig, dbus, libXi, libXcursor, libXdamage, libXrandr
, libXcomposite, libXext, libXfixes, libXrender, libX11, libXtst, libXScrnSaver
, libxcb, libuuid, nss, nspr, alsaLib, cups, expat, udev, libpulseaudio
, at-spi2-atk, at-spi2-core }:

stdenv.mkDerivation rec {
  pname = "hyper";
  version = "3.1.0-canary.4";

  src = fetchurl {
    url = "https://github.com/vercel/hyper/releases/download/v${version}/hyper_${version}_amd64.deb";
    sha256 = "0z61sd3r9778d58xs6xjkz88c7crjk9vx9p1iw07i7pjj11wjrdb";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out/"
    ln -s "$out/opt/Hyper/hyper" "$out/bin/hyper"
    mv usr/* "$out/"
  '';

  preFixup = let
    libPath = stdenv.lib.makeLibraryPath [
      stdenv.cc.cc gtk3 gnome2.GConf atk glib pango gdk-pixbuf cairo freetype fontconfig dbus
      libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes libxcb
      libXrender libX11 libXtst libXScrnSaver libuuid nss nspr alsaLib cups expat udev
      libpulseaudio at-spi2-atk at-spi2-core
    ];
  in ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:\$ORIGIN" "$out/opt/Hyper/hyper"
  '';

  dontPatchELF = true;

  meta = with lib; {
    description = "A terminal built on web technologies";
    homepage    = "https://hyper.is/";
    maintainers = with maintainers; [ pradyuman puffnfresh ];
    license     = licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };
}
