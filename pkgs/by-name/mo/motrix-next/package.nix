{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  pnpm_10,
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
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "motrix-next";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "AnInsomniacy";
    repo = "motrix-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DeqHF36iH2kPi4F7RU5Ipde0lnwGWJqHfu4kz3znexg=";
  };

  cargoHash = "sha256-v+0dWo3w42wglv23Ydj0+Cb5HXF2fZ4Z0DC8EIsN5ww=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    hash = "sha256-WvcN4LLRKiOxYEjImZ7VerwHFj33ELJvDKyP3F2UYG8=";
    fetcherVersion = 3;
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

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  checkFlags = lib.optional stdenv.hostPlatform.isDarwin "--skip=commands::protocol::tests::macos_tests::get_default_handler_bundle_id_returns_some_for_https";

  # Deactivate the upstream update mechanism
  postPatch = ''
    jq '
      .bundle.createUpdaterArtifacts = false |
      .plugins.updater = {"active": false, "pubkey": "", "endpoints": []}
    ' \
    src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
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
      --set-default APPIMAGE $out/bin/motrix-next
    )
    wrapGApp $out/bin/motrix-next
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Full-featured download manager, rebuilt from scratch with Tauri 2, Vue 3, and Rust";
    homepage = "https://github.com/AnInsomniacy/motrix-next";
    changelog = "https://github.com/AnInsomniacy/motrix-next/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      gpl2Plus
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # ships an upstream-provided aria2c binary (statically linked, max connections increased)
      # source for this binary: https://github.com/AnInsomniacy/aria2-builder
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    mainProgram = "motrix-next";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
