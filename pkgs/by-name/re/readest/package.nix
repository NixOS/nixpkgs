{
  rustPlatform,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  cargo-tauri,
  nodejs,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook3,
  fetchFromGitHub,
  gtk3,
  librsvg,
  openssl,
  autoPatchelfHook,
  lib,
  nix-update-script,
  moreutils,
  jq,
  gst_all_1,

  # NOTE: this is enabled by default for better compatibility, but it may slow
  # down performance.
  withNvidiaFix ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "readest";
  version = "0.9.99";

  src = fetchFromGitHub {
    owner = "readest";
    repo = "readest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fcil35siaGrooW8+R2WrZaR5qHPJXIYOU/Au1YKlb2M=";
    fetchSubmodules = true;
  };

  postUnpack = ''
    # pnpm.configHook has to write to ../.., as our sourceRoot is set to
    # apps/readest-app
    chmod -R +w .
  '';

  sourceRoot = "${finalAttrs.src.name}/apps/readest-app";

  pnpmRoot = "../..";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-/bzjOdpvuPLBMvX/q1WaO3lFg5/jLz5Ypr5OojssXUI=";
  };

  cargoRoot = "../..";
  cargoHash = "sha256-qYBHYjwfGkKmGXN8caamZ6/XGtnxe+lmy6dIpdMwS/I=";

  buildAndTestSubdir = "src-tauri";

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false' \
      --replace-fail '"Readest"' '"readest"'
    jq 'del(.plugins."deep-link")' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
    substituteInPlace src/services/constants.ts \
      --replace-fail "autoCheckUpdates: true" "autoCheckUpdates: false" \
      --replace-fail "telemetryEnabled: true" "telemetryEnabled: false"
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pnpmConfigHook
    pnpm_10
    pkg-config
    wrapGAppsHook3
    autoPatchelfHook
    moreutils
    jq
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    librsvg
    openssl
    # TTS
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  preBuild = ''
    # set up pdfjs and simplecc
    pnpm setup-vendors
  '';

  preFixup = lib.optionalString withNvidiaFix ''
    # fix Nvidia issues with Tauri
    # https://github.com/tauri-apps/tauri/issues/9394
    # https://github.com/tauri-apps/tauri/issues/9304
    gappsWrapperArgs+=(
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER 1
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, feature-rich ebook reader";
    homepage = "https://github.com/readest/readest";
    changelog = "https://github.com/readest/readest/releases/tag/v${finalAttrs.version}";
    mainProgram = "readest";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ eljamm ];
    platforms = lib.platforms.linux;
  };
})
