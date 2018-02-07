{ stdenv, fetchurl, glibc, mesa, freetype, glib, libSM, libICE, libXi, libXv
, libXrender, libXrandr, libXfixes, libXcursor, libXinerama, libXext, libX11, qt4
, zlib, fontconfig, dpkg }:

let
  arch =
    if stdenv.system == "x86_64-linux" then "amd64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Unsupported system ${stdenv.system}";
  sha256 =
    if arch == "amd64"
    then "0dwnppn5snl5bwkdrgj4cyylnhngi0g66fn2k41j3dvis83x24k6"
    else "0gndbxrj3kgc2dhjqwjifr3cl85hgpm695z0wi01wvwzhrjqs0l2";
  fullPath = stdenv.lib.makeLibraryPath [
    glibc
    glib
    stdenv.cc.cc
    libSM
    libICE
    libXi
    libXv
    mesa
    libXrender
    libXrandr
    libXfixes
    libXcursor
    libXinerama
    freetype
    libXext
    libX11
    qt4
    zlib
    fontconfig
  ];
in
stdenv.mkDerivation rec {
  version = "7.1.4.1529";
  name = "googleearth-${version}";

  src = fetchurl {
    url = "https://dl.google.com/earth/client/current/google-earth-stable_current_${arch}.deb";
    inherit sha256;
  };

  phases = "unpackPhase installPhase";

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase =''
    mkdir $out
    mv usr/* $out/
    rmdir usr
    mv * $out/
    rm $out/bin/google-earth $out/opt/google/earth/free/google-earth
    ln -s $out/opt/google/earth/free/googleearth $out/bin/google-earth

    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${fullPath}:\$ORIGIN" \
      $out/opt/google/earth/free/googleearth-bin

    for a in $out/opt/google/earth/free/*.so* ; do
      patchelf --set-rpath "${fullPath}:\$ORIGIN" $a
    done
  '';

  dontPatchELF = true;

  meta = {
    description = "A world sphere viewer";
    homepage = http://earth.google.com;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
