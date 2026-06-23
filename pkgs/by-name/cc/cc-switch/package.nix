{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  copyDesktopItems,
  jq,
  makeDesktopItem,
  nodejs,
  pkg-config,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  wrapGAppsHook3,

  glib-networking,
  libayatana-appindicator,
  libsoup_3,
  openssl,
  webkitgtk_4_1,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cc-switch";
  version = "3.16.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "farion1231";
    repo = "cc-switch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jj7FHJtXn127hqpjCe6buxvJNCtWxRe5HZPY8NRcglM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-Vs+/KLICqciF7dnC3iRH9TFzNCtXDgOkWFPLxdwA0rE=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # libappindicator-sys dlopens libayatana-appindicator3.so.1 at runtime; autoPatchelf can't catch it.
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-PfTkrD3ts/OugZ5qM82tTfWwSOcSddgDYzQhr6wLvOg=";

  nativeBuildInputs = [
    jq
    nodejs
    pnpmConfigHook
    pnpm_10
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    glib-networking
    libayatana-appindicator
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  # tauri-build embeds frontendDist (../dist) at compile time; populate it
  # before cargo build runs.
  preBuild = ''
    pnpm run build:renderer
  '';

  # cc_switch_lib is an internal staticlib+cdylib+rlib; only the binary is needed.
  # tauri/custom-protocol enables embedded-asset serving via `tauri://localhost/`;
  # without it, WKWebView/webkit2gtk fall through to devUrl (http://localhost:3000)
  # and blank-screen with NSURLErrorCannotConnectToHost.
  cargoBuildFlags = [
    "--bin"
    "cc-switch"
    "--features=tauri/custom-protocol"
  ];

  # Proxy startup test binds to a local address, which the darwin sandbox blocks.
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=services::provider::tests::update_current_claude_provider_syncs_live_when_proxy_takeover_detected_without_backup"
  ];

  postInstall = ''
    rm -rf $out/lib
    install -Dm644 src-tauri/icons/32x32.png $out/share/icons/hicolor/32x32/apps/cc-switch.png
    install -Dm644 src-tauri/icons/128x128.png $out/share/icons/hicolor/128x128/apps/cc-switch.png
    install -Dm644 src-tauri/icons/128x128@2x.png $out/share/icons/hicolor/256x256/apps/cc-switch.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "cc-switch";
      desktopName = "CC Switch";
      exec = finalAttrs.meta.mainProgram;
      icon = "cc-switch";
      comment = finalAttrs.meta.description;
      categories = [
        "Development"
        "Utility"
      ];
      mimeTypes = [ "x-scheme-handler/ccswitch" ];
      startupWMClass = "cc-switch";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "All-in-one assistant for Claude Code, Codex, OpenCode, Gemini CLI and other AI coding agents";
    homepage = "https://ccswitch.io";
    downloadPage = "https://github.com/farion1231/cc-switch";
    changelog = "https://github.com/farion1231/cc-switch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "cc-switch";
    maintainers = with lib.maintainers; [ imcvampire ];
    platforms = lib.platforms.unix;
  };
})
