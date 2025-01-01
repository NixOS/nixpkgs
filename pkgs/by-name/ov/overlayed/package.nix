{
  rustPlatform,
  lib,
  callPackage,
  pkg-config,
  openssl,
  libsoup,
  webkitgtk,
  fetchFromGitHub,
  libayatana-appindicator,
}:

rustPlatform.buildRustPackage rec {
  pname = "overlayed";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "overlayeddev";
    repo = "overlayed";
    rev = "refs/tags/v${version}";
    hash = "sha256-yS1u7pp7SfmqzoH0QOAH060uo3nFb/N9VIng0T21tVw=";
  };

  sourceRoot = "${src.name}/apps/desktop/src-tauri";

  webui = callPackage ./webui.nix {
    inherit meta src version;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    webkitgtk
    libsoup
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-window-state-0.1.1" = "sha256-2cdO+5YAP7MOK0/YKclQemK4N9ci2JX3AfmMaeauwNI=";
      "tauri-nspanel-0.0.0" = "sha256-tQHY0OX37b4dqhs89phYIzw7JzEPmMJo5e/jlyzxdMg=";
      "tauri-plugin-single-instance-0.0.0" = "sha256-S1nsT/Dr0aIJdiPnW1FGamCth7CDMNAp4v34tpWqjHg=";
    };
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    substituteInPlace ./tauri.conf.json \
      --replace-fail '"distDir": "../dist",' '"distDir": "${webui}",' \
      --replace-fail '"beforeBuildCommand": "pnpm build"' '"beforeBuildCommand": ""'
  '';

  meta = {
    description = "Modern discord voice chat overlay";
    homepage = "https://github.com/overlayeddev/overlayed";
    changelog = "https://github.com/overlayeddev/overlayed/releases/tag/v${version}";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.agpl3Plus;
    mainProgram = "overlayed";
  };
}
