{
  stdenv,
  makeBinaryWrapper,
  lib,
  libsForQt5,
  python3Packages,
}:
stdenv.mkDerivation {
  inherit (python3Packages.gepetto-viewer-unwrapped) pname version meta;
  buildInputs = [ makeBinaryWrapper ];
  propagatedBuildInputs = [ python3Packages.gepetto-viewer-corba ];
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    makeBinaryWrapper ${lib.getExe python3Packages.gepetto-viewer-unwrapped} $out/bin/gepetto-gui \
      --set GEPETTO_GUI_PLUGIN_DIRS ${python3Packages.gepetto-viewer-corba}/lib \
      --set QP_QPA_PLATFORM_PLUGIN_PATH ${libsForQt5.qtbase.bin}/lib/qt-${libsForQt5.qtbase.version}/plugins \
      --set QT_QPA_PLATFORM xcb
  '';
}
