{
  pname,
  version,
  src,
  libayatana-appindicator,
  vendor-hash,
  glib,
  webui,
  pkg-config,
  libsoup,
  rustPlatform,
  makeDesktopItem,
  libsForQt5,
  kdePackages,
  meta,
  webkitgtk_4_1,
  openssl,
}:

rustPlatform.buildRustPackage {
  inherit version src meta;
  pname = "${pname}-unwrapped";
  sourceRoot = "${src.name}/src-tauri";

  useFetchCargoVendor = true;
  cargoHash = vendor-hash;

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    substituteInPlace $cargoDepsCopy/sysproxy-*/src/linux.rs \
      --replace-fail '"gsettings"' '"${glib.bin}/bin/gsettings"' \
      --replace-fail '"kreadconfig5"' '"${libsForQt5.kconfig}/bin/kreadconfig5"' \
      --replace-fail '"kreadconfig6"' '"${kdePackages.kconfig}/bin/kreadconfig6"' \
      --replace-fail '"kwriteconfig5"' '"${libsForQt5.kconfig}/bin/kwriteconfig5"' \
      --replace-fail '"kwriteconfig6"' '"${kdePackages.kconfig}/bin/kwriteconfig6"'

    substituteInPlace ./tauri.conf.json \
      --replace-fail '"frontendDist": "../dist",' '"frontendDist": "${webui}",' \
      --replace-fail '"beforeBuildCommand": "pnpm run web:build"' '"beforeBuildCommand": ""'
    sed -i -e '/externalBin/d' -e '/resources/d' tauri.conf.json
    sed -i -e '/sidecar/d' -e '/resources/d' tauri.linux.conf.json
    chmod 777 ../.cargo
    rm ../.cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    openssl
    libsoup
    webkitgtk_4_1
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
