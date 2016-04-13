{stdenv, fetchurl, unzip, libX11, libcxxabi, glib, xorg, qt4, fontconfig, phonon, freetype, zlib, libpng12, libICE, libXrender, cups, lib}:

stdenv.mkDerivation rec{
  name = "wpsoffice-${version}";
  version = "10.1.0.5503";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://kdl.cc.ksosoft.com/wps-community/download/a20/wps-office_10.1.0.5503~a20p2_x86_64.tar.xz";
    sha256 = "0h9f8s7zkpd056ibrj978mr04imv631sp1wljplh99l5ncns6hws";
  };
  
  meta = {
    description = "Office program originally named Kingsoft Office";
    homepage = http://wps-community.org/;
    platforms = [ "x86_64-linux" ];
    # Binary for i686 is also available if someone can package it
    license = lib.licenses.unfreeRedistributable;
  };

  libPath = stdenv.lib.makeLibraryPath [
    libX11
    libcxxabi
    libpng12
    glib
    xorg.libSM
    xorg.libXext
    fontconfig
    phonon
    zlib
    freetype
    libICE
    cups
    libXrender
  ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    cp -r . "$out"
    chmod +x "$out/office6/wpp"
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --force-rpath --set-rpath "$out/office6:$libPath" "$out/office6/wpp"
    chmod +x "$out/office6/wps"
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --force-rpath --set-rpath "$out/office6:$libPath" "$out/office6/wps"
    chmod +x "$out/office6/et"
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --force-rpath --set-rpath "$out/office6:$libPath" "$out/office6/et"
    mkdir -p "$out/bin/"
    ln -s "$out/office6/wpp" "$out/bin/wpspresentation"
    ln -s "$out/office6/wps" "$out/bin/wpswriter"
    ln -s "$out/office6/et" "$out/bin/wpsspreadsheets"
  '';
}
