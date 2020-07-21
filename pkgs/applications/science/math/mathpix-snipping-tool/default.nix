{ stdenv, fetchurl, squashfsTools, makeWrapper, xorg, qt5 }:

stdenv.mkDerivation rec {
  pname = "mathpix-snipping-tool";
  version = "02.04.0002";
  rev = "155";

  # for updates check: https://snapcraft.io/mathpix-snipping-tool
  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/jnlZEYdmdXGhh6oJTtMsawNGZzEWmMhk_${rev}.snap";
    sha256 = "rUfjMRc4DZa3FTtAb2H9qAasTeKU4c6R8EWsg8gcUS4=";
  };

  buildInputs = [ squashfsTools makeWrapper ];

  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src" 'usr/bin/mathpix-snipping-tool' 'meta/gui/mathpix-snipping-tool.desktop' 'meta/gui/icon.svg'
    cd squashfs-root
    runHook postUnpack
  '';

  libPath = stdenv.lib.makeLibraryPath [
    qt5.qtbase
    qt5.qtwebkit
    qt5.qtx11extras
    stdenv.cc.cc # libstdc++.so.6
    xorg.libX11 # libX11.so.6
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv ./usr/* $out/

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $libPath \
      $out/bin/mathpix-snipping-tool

    wrapProgram $out/bin/mathpix-snipping-tool \
      --set QT_QPA_PLATFORM_PLUGIN_PATH ${qt5.qtbase.bin}/lib/qt-*/plugins/platforms

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://mathpix.com/";
    description = "Extract equations from PDFs or handwritten notes in seconds just by taking a screenshot.";
    license = licenses.unfree;
    maintainers = with maintainers; [ offline ];
    platforms = [ "x86_64-linux" ];
  };
}
