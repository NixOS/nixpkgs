{
  pname,
  version,
  src,
  libayatana-appindicator,
  sysproxy-hash,
  webui,
  pkg-config,
  rustPlatform,
  makeDesktopItem,
  meta,
  webkitgtk,
  openssl,
}:
rustPlatform.buildRustPackage {
  inherit version src meta;
  pname = "${pname}-unwrapped";
  sourceRoot = "${src.name}/src-tauri";

  cargoLock = {
    lockFile = ./Cargo-tauri.lock;
    outputHashes = {
      "sysproxy-0.3.0" = sysproxy-hash;
    };
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    substituteInPlace ./tauri.conf.json \
      --replace-fail '"distDir": "../dist",' '"distDir": "${webui}",' \
      --replace-fail '"beforeBuildCommand": "pnpm run web:build"' '"beforeBuildCommand": ""'
    sed -i -e '/externalBin/d' -e '/resources/d' tauri.conf.json
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    openssl
    webkitgtk
  ];

  postInstall = ''
    install -DT icons/128x128@2x.png $out/share/icons/hicolor/128x128@2/apps/clash-verge.png
    install -DT icons/128x128.png $out/share/icons/hicolor/128x128/apps/clash-verge.png
    install -DT icons/32x32.png $out/share/icons/hicolor/32x32/apps/clash-verge.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "clash-verge-rev";
      exec = "clash-verge %u";
      icon = "clash-verge-rev";
      desktopName = "Clash Verge Rev";
      genericName = meta.description;
      mimeTypes = [ "x-scheme-handler/clash" ];
      type = "Application";
      terminal = false;
    })
  ];
}
