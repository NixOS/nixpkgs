{
  darwin,
  lib,
  libsForQt5,
  makeBinaryWrapper,
  python3Packages,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (python3Packages.gepetto-viewer-unwrapped) pname version meta;
  buildInputs = [ makeBinaryWrapper ];
  propagatedBuildInputs = [ python3Packages.gepetto-viewer-corba ];
  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ darwin.autoSignDarwinBinariesHook ];
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    makeBinaryWrapper ${lib.getExe python3Packages.gepetto-viewer-unwrapped} $out/bin/gepetto-gui \
      --set GEPETTO_GUI_PLUGIN_DIRS ${python3Packages.gepetto-viewer-corba}/lib
  '';
}
