{ stdenv, lib, fetchurl, openssl, python3Packages, makeWrapper, symlinkJoin
, qgis3-unwrapped
}:
with lib;
symlinkJoin rec {
  inherit (qgis3-unwrapped) version;
  name = "qgis-${version}";

  paths = [ qgis3-unwrapped ];

  nativeBuildInputs = [ makeWrapper python3Packages.wrapPython ];

  # extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs = qgis3-unwrapped.pythonBuildInputs;

  # use the source archive directly to avoid rebuilding when changing qgis distro
  inherit (qgis3-unwrapped) src;

  postBuild = ''
    unpackPhase

    buildPythonPath "$pythonInputs"

    wrapProgram $out/bin/qgis \
      --prefix PATH : $program_PATH \
      --set PYTHONPATH $program_PYTHONPATH

    # desktop link
    mkdir -p $out/share/applications

    sed "/^Exec=/c\Exec=$out/bin/qgis" \
      < $sourceRoot/debian/qgis.desktop \
      > $out/share/applications/qgis.desktop

    # mime types
    mkdir -p $out/share/mime/packages
    cp $sourceRoot/debian/qgis.xml $out/share/mime/packages

    # vector icon
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp $sourceRoot/images/icons/qgis_icon.svg $out/share/icons/hicolor/scalable/apps/qgis.svg
  '';
}
