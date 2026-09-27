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
  glib-networking,
  openssl,
  webkitgtk_4_1,
  libayatana-appindicator,
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
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "AnInsomniacy";
    repo = "rayburst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2GuZEFwua3SY7EVywAi0r8ITz/9cUbks7K7ux8SijAo=";
  };

  cargoHash = "sha256-xxKzyefv4UjbOW5q/ei6urXETEDZnN3BeUjAkOwu7ZA=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    hash = "sha256-zFV87FMMtJQXcus3p0OQDUQ1yVgJ0RgN2EangBw6Y1s=";
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
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  # we don't want to wrap aria2c
  dontWrapGApps = true;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
    libayatana-appindicator
  ];

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
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libayatana-appindicator
        ]
      }
      --suffix PATH : ${
        lib.makeBinPath [
          desktop-file-utils
          xdg-utils
        ]
      }
      # Tricky way to make the protocol handler desktop file point to the wrapper
      --set-default APPIMAGE rayburst
    )
    wrapGApp $out/bin/rayburst
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Desktop download manager for files, torrents and streams";
    homepage = "https://github.com/AnInsomniacy/rayburst";
    changelog = "https://github.com/AnInsomniacy/rayburst/releases/tag/v${finalAttrs.version}";
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
