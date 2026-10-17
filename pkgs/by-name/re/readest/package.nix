{
  rustPlatform,
  pnpm_11,
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
  glib-networking,
  autoPatchelfHook,
  lib,
  nix-update-script,
  moreutils,
  jq,
  gst_all_1,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "readest";
  version = "0.12.16";

  src = fetchFromGitHub {
    owner = "readest";
    repo = "readest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XNN66MB13yqHCvnBUgPmdghRnXA7Kz13E0j82EqxocU=";
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
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-LPm50VC7KU1wysxSUxwFZ7pNZutULct05NB5WgjmTws=";
    pnpmInstallFlags = [
      # Increase number of fetch attempts to work around timeout issues on slow
      # networks: "TimeoutError: The operation was aborted due to timeout".
      #
      # If this still happens on your network, consider changing some of the
      # fetch setting and opening a pull request:
      # https://pnpm.io/settings#request-settings
      "--fetch-retries=5"
    ];
  };

  cargoRoot = "../..";
  cargoHash = "sha256-8wiIf4MFgOUPvljgLN7kbx3H/r57jjiqsxN5P5rZCAA=";

  buildAndTestSubdir = "src-tauri";

  postPatch = ''
    # The frontend is built explicitly in preBuild.
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail \
        '"beforeBuildCommand": "pnpm build && pnpm upload-sourcemaps"' \
        '"beforeBuildCommand": ""' \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false' \
      --replace-fail '"productName": "Readest"' '"productName": "readest"'

    # Do not generate browser source maps; the upstream cleanup step is skipped.
    substituteInPlace next.config.mjs \
      --replace-fail \
        'productionBrowserSourceMaps: exportOutput' \
        'productionBrowserSourceMaps: false'

    jq 'del(.plugins."deep-link")' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
    substituteInPlace src/services/constants.ts \
      --replace-fail "autoCheckUpdates: true" "autoCheckUpdates: false" \
      --replace-fail "telemetryEnabled: true" "telemetryEnabled: false"
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pnpmConfigHook
    pnpm_11
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
    glib-networking
    # TTS
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  preBuild = ''
    # Set up pdf.js assets.
    pnpm setup-vendors

    # Tauri embeds frontendDist during the Rust build.
    pnpm --filter @readest/readest-app build
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, feature-rich ebook reader";
    homepage = "https://github.com/readest/readest";
    changelog = "https://github.com/readest/readest/releases/tag/v${finalAttrs.version}";
    mainProgram = "readest";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      eljamm
      kasifrasi
    ];
    platforms = lib.platforms.linux;
  };
})
