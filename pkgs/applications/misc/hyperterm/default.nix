{ stdenv, lib, fetchurl, dpkg, gtk, atk, glib, pango, gdk_pixbuf, cairo
, freetype, fontconfig, dbus, libXi, libXcursor, libXdamage, libXrandr
, libXcomposite, libXext, libXfixes, libXrender, libX11, libXtst, libXScrnSaver
, GConf, nss, nspr, alsaLib, cups, expat, libudev, libpulseaudio }:

let
  libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc gtk atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
    libXrender libX11 libXtst libXScrnSaver GConf nss nspr alsaLib cups expat libudev libpulseaudio
  ];
in
stdenv.mkDerivation rec {
  version = "0.7.6";
  name = "hyperterm-${version}";
  src = fetchurl {
    url = https://github.com/zeit/hyperterm/releases/download/v0.7.1/hyperterm-0.7.1.deb;
    sha256 = "1xdwhmzlkg1ly1xgsbv99xk4x1g1x270vx1b12dvf10ck5x9v63a";
  };
  buildInputs = [ dpkg ];
  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    ln -s "$out/opt/HyperTerm/HyperTerm" "$out/bin/HyperTerm"
    mv opt "$out/"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:\$ORIGIN" "$out/opt/HyperTerm/HyperTerm"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}" "$out/opt/HyperTerm/resources/app/node_modules/child_pty/build/Release/exechelper"
    mv usr/* "$out/"
  '';
  dontPatchELF = true;
  meta = with lib; {
    description = "A terminal built on web technologies";
    homepage    = https://hyperterm.org/;
    maintainers = with maintainers; [ puffnfresh ];
    license     = licenses.mit;
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
