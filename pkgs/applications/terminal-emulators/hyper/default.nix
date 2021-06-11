{ stdenv, lib, fetchurl, dpkg, atk, glib, pango, gdk-pixbuf, gnome2, gtk3, cairo
, freetype, fontconfig, dbus, libXi, libXcursor, libXdamage, libXrandr
, libXcomposite, libXext, libXfixes, libXrender, libX11, libXtst, libXScrnSaver
, libxcb, nss, nspr, alsa-lib, cups, expat, udev, libpulseaudio, at-spi2-atk }:

let
  libPath = lib.makeLibraryPath [
    stdenv.cc.cc gtk3 gnome2.GConf atk glib pango gdk-pixbuf cairo freetype fontconfig dbus
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes libxcb
    libXrender libX11 libXtst libXScrnSaver nss nspr alsa-lib cups expat udev libpulseaudio
    at-spi2-atk
  ];
in
stdenv.mkDerivation rec {
  version = "3.0.2";
  pname = "hyper";
  src = fetchurl {
    url = "https://github.com/zeit/hyper/releases/download/${version}/hyper_${version}_amd64.deb";
    sha256 = "0fv4wv5f8nc739bna83qxmgrvvbyq4w9ch764q2f12wjygrz336p";
  };
  buildInputs = [ dpkg ];
  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out/"
    ln -s "$out/opt/Hyper/hyper" "$out/bin/hyper"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:$out/opt/Hyper:\$ORIGIN" "$out/opt/Hyper/hyper"
    mv usr/* "$out/"
  '';
  dontPatchELF = true;
  meta = with lib; {
    description = "A terminal built on web technologies";
    homepage    = "https://hyper.is/";
    maintainers = with maintainers; [ puffnfresh ];
    license     = licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };
}
