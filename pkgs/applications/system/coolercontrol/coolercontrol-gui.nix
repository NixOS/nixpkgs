{
  cmake,
  stdenv,
  qt6,
}:

{
  version,
  src,
  meta,
}:

stdenv.mkDerivation {
  pname = "coolercontrol";
  inherit version src;
  sourceRoot = "${src.name}/coolercontrol";

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
  ];

  postInstall = ''
    install -Dm644 "${src}/packaging/metadata/org.coolercontrol.CoolerControl.desktop" -t "$out/share/applications/"
    install -Dm644 "${src}/packaging/metadata/org.coolercontrol.CoolerControl.metainfo.xml" -t "$out/share/metainfo/"
    install -Dm644 "${src}/packaging/metadata/org.coolercontrol.CoolerControl.png" -t "$out/share/icons/hicolor/256x256/apps/"
    install -Dm644 "${src}/packaging/metadata/org.coolercontrol.CoolerControl.svg" -t "$out/share/icons/hicolor/scalable/apps/"
  '';

  meta = meta // {
    description = "${meta.description} (GUI)";
    mainProgram = "coolercontrol";
  };
}
