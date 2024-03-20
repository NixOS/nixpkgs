{ lib
, buildNpmPackage
, rustPlatform
, dbus
, freetype
, gtk3
, libsoup
, openssl
, pkg-config
, webkitgtk
, libappindicator
, makeWrapper
, coolercontrol
}:

{ version
, src
, meta
}:

rustPlatform.buildRustPackage {
  pname = "coolercontrol";
  inherit version src;
  sourceRoot = "${src.name}/coolercontrol-ui/src-tauri";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-autostart-0.0.0" = "sha256-ATw3dbvG3IsLaLBg5wGk7hVRqipwL4xPGKdtD9a5VIw=";
    };
  };

  buildFeatures = [ "custom-protocol" ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
    freetype
    libsoup
    gtk3
    webkitgtk
    libappindicator
  ];

  checkFeatures = [ "custom-protocol" ];

  # copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  postPatch = ''
    mkdir -p ui-build
    cp -R ${coolercontrol.coolercontrol-ui-data}/* ui-build/
    substituteInPlace tauri.conf.json --replace '"distDir": "../dist"' '"distDir": "ui-build"'
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
