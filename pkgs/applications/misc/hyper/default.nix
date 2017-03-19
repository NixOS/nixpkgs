{ stdenv, lib, fetchurl, dpkg, gtk2, atk, glib, pango, gdk_pixbuf, cairo
, freetype, fontconfig, dbus, libXi, libXcursor, libXdamage, libXrandr
, libXcomposite, libXext, libXfixes, libXrender, libX11, libXtst, libXScrnSaver
, GConf, nss, nspr, alsaLib, cups, expat, libudev, libpulseaudio }:

let
  libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc gtk2 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
    libXrender libX11 libXtst libXScrnSaver GConf nss nspr alsaLib cups expat libudev libpulseaudio
  ];
in
stdenv.mkDerivation rec {
  version = "1.3.1";
  name = "hyper-${version}";
  src = fetchurl {
    url = "https://github.com/zeit/hyper/releases/download/${version}/hyper_${version}.deb";
    sha256 = "1i1rnq10a9kid8lggrd1gp9g08v98la8idnyk4kx4vn0svqy7nvl";
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
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:\$ORIGIN" "$out/opt/Hyper/hyper"
    mv usr/* "$out/"
  '';
  dontPatchELF = true;
  meta = with lib; {
    description = "A terminal built on web technologies";
    homepage    = https://hyper.is/;
    maintainers = with maintainers; [ puffnfresh ];
    license     = licenses.mit;
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
