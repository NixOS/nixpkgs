{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  pkg-config,
  jq,
  moreutils,
  autoPatchelfHook,
  glib-networking,
  openssl,
  webkitgtk_4_1,
  libayatana-appindicator,
  actool,
  wrapGAppsHook4,
  desktop-file-utils,
  xdg-utils,
  nix-update-script,
}:
let
  pnpm = pnpm_11;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rayburst";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "AnInsomniacy";
    repo = "rayburst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dQGkY681vsPzeKK6a1bUY89Me6WLQqPs6vdlOrl9TMk=";
  };

  cargoHash = "sha256-2OwbO27u4faulirN6k/mzyoVhhTG3xZ8lbHjBLSXtpE=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    hash = "sha256-uSS4R3X8SsWoyJn87rcJ1dhDdG0r0Sebn3Q+95RabCE=";
    fetcherVersion = 4;
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    pnpmConfigHook
    pnpm
    nodejs

    pkg-config
    jq
    moreutils
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    wrapGAppsHook4
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ actool ];

  # we don't want to wrap aria2c
  dontWrapGApps = true;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
    libayatana-appindicator
    # the bundled aria2-next binary links libstdc++/libgcc_s dynamically
    stdenv.cc.cc.lib
  ];

  # `libappindicator-sys` dlopen()s the tray library from the executable, but
  # it has no DT_NEEDED entry, so autoPatchelfHook cannot discover it.
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [ libayatana-appindicator ];

  __structuredAttrs = true;

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  doCheck = false;

  tauriBuildFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "--no-sign" ];

  postPatch = ''
    substituteInPlace scripts/build-native-messaging-launcher.mjs \
      --replace-fail "join(tauriDir, 'target'" "join(root, 'target'"

    # Deactivate the upstream update mechanism
    jq '
      .bundle.createUpdaterArtifacts = false |
      .plugins.updater = {"active": false, "pubkey": "", "endpoints": []}
    ' \
    src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --suffix PATH : ${
        lib.makeBinPath [
          desktop-file-utils
          xdg-utils
        ]
      }
      # Tricky way to make the protocol handler desktop file point to the wrapper
      --set APPIMAGE "$out/bin/rayburst"
    )
    wrapGApp $out/bin/rayburst
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Desktop download manager for files, torrents and streams";
    homepage = "https://github.com/AnInsomniacy/rayburst";
    changelog = "https://github.com/AnInsomniacy/rayburst/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      gpl2Plus
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # ships a binary of aria2c fork
      # source for this fork: https://github.com/AnInsomniacy/aria2-next
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    mainProgram = "rayburst";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
