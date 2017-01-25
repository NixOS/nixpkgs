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
  version = "0.8.3";
  name = "hyper-${version}";
  src = fetchurl {
    url = "https://github.com/zeit/hyper/releases/download/${version}/hyper-${version}-amd64.deb";
    sha256 = "1683gc0fhifn89l9h67yz02pk1xz7p5l3qpiyddr9w21qr9h3lhq";
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
    ln -s "$out/opt/Hyper/Hyper" "$out/bin/Hyper"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:\$ORIGIN" "$out/opt/Hyper/Hyper"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}" "$out/opt/Hyper/resources/app/node_modules/child_pty/build/Release/exechelper"
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
