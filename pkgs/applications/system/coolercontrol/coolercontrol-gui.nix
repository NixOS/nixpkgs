{
  lib,
  rustPlatform,
  dbus,
  freetype,
  gtk3,
  libsoup_3,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  libappindicator,
  makeWrapper,
  coolercontrol,
}:

{
  version,
  src,
  meta,
}:

rustPlatform.buildRustPackage {
  pname = "coolercontrol";
  inherit version src;
  sourceRoot = "${src.name}/coolercontrol-ui/src-tauri";

  cargoHash = "sha256-0Ud5S4T5+5eBuvD5N64NAvbK0+tTozKsPhsNziCEu3I=";

  buildFeatures = [ "custom-protocol" ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
    freetype
    libsoup_3
    gtk3
    webkitgtk_4_1
    libappindicator
  ];

  checkFeatures = [ "custom-protocol" ];

  # copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  postPatch = ''
    mkdir -p ui-build
    cp -R ${coolercontrol.coolercontrol-ui-data}/* ui-build/
    substituteInPlace tauri.conf.json --replace '"frontendDist": "../dist"' '"frontendDist": "ui-build"'
  '';

  postInstall = ''
    install -Dm644 "${src}/packaging/metadata/org.coolercontrol.CoolerControl.desktop" -t "$out/share/applications/"
    install -Dm644 "${src}/packaging/metadata/org.coolercontrol.CoolerControl.metainfo.xml" -t "$out/share/metainfo/"
    install -Dm644 "${src}/packaging/metadata/org.coolercontrol.CoolerControl.png" -t "$out/share/icons/hicolor/256x256/apps/"
    install -Dm644 "${src}/packaging/metadata/org.coolercontrol.CoolerControl.svg" -t "$out/share/icons/hicolor/scalable/apps/"
    wrapProgram $out/bin/coolercontrol \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libappindicator ]}
  '';

  meta = meta // {
    description = "${meta.description} (GUI)";
    mainProgram = "coolercontrol";
  };
}
