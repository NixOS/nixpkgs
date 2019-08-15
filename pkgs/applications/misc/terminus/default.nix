{ stdenv, lib, fetchurl, dpkg, gnome2, gtk2, atk, glib, pango, gdk-pixbuf, cairo
, freetype, fontconfig, dbus, libXi, libXcursor, libXdamage, libXrandr
, libXcomposite, libXext, libXfixes, libXrender, libX11, libXtst, libXScrnSaver
, libxcb, makeWrapper, nodejs
, nss, nspr, alsaLib, cups, expat, systemd, libpulseaudio }:

let
  libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc gtk2 atk glib pango gdk-pixbuf cairo freetype fontconfig dbus
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes libxcb
    libXrender libX11 libXtst libXScrnSaver gnome2.GConf nss nspr alsaLib cups expat systemd libpulseaudio
  ];
in
stdenv.mkDerivation rec {
  version = "1.0.0-alpha.42";
  pname = "terminus";
  src = fetchurl {
    url = "https://github.com/Eugeny/terminus/releases/download/v${version}/terminus_${version}_amd64.deb";
    sha256 = "1r5n75n71zwahg4rxlnf9qzrb0651gxv0987m6bykqmfpnw91nmb";
  };
  buildInputs = [ dpkg makeWrapper ];
  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out/"
    ln -s "$out/opt/Terminus/terminus" "$out/bin/terminus"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:\$ORIGIN" "$out/opt/Terminus/terminus"
    mv usr/* "$out/"
    wrapProgram $out/bin/terminus --prefix PATH : ${lib.makeBinPath [ nodejs ]}
  '';
  dontPatchELF = true;
  meta = with lib; {
    description = "A terminal for a more modern age";
    homepage    = https://eugeny.github.io/terminus/;
    maintainers = with maintainers; [ jlesquembre ];
    license     = licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };
}
