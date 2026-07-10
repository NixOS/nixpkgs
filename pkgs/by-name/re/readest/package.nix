{
  stdenv,
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
  version = "0.11.17";

  src = fetchFromGitHub {
    owner = "readest";
    repo = "readest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vueP/UGu1G+DnwqJ7GhcYIxIsyTeFGYIiz7Iu0fs3NA=";
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
    hash = "sha256-wtWYdIfqytwn8PNahbQ/WxJuhhH1lbgNshQy6V0vvcA=";
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
  cargoHash = "sha256-QxsiYl7mG+kS35pcU8/WLQA+f3gepe7qrHelhUzONbY=";

  buildAndTestSubdir = "src-tauri";

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false' \
      --replace-fail '"Readest"' '"readest"'
    jq 'del(.plugins."deep-link")' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
    substituteInPlace src/services/constants.ts \
      --replace-fail "autoCheckUpdates: true" "autoCheckUpdates: false" \
      --replace-fail "telemetryEnabled: true" "telemetryEnabled: false"

    jq '.version = "${finalAttrs.version}"' package.json | sponge package.json

    mkdir -p src-tauri/plugins/tauri-plugin-turso/dist-js
    cp -r ${finalAttrs.passthru.tursoPlugin} src-tauri/plugins/tauri-plugin-turso/dist-js
    jq '.scripts.build = "true"' \
      src-tauri/plugins/tauri-plugin-turso/package.json | \
      sponge src-tauri/plugins/tauri-plugin-turso/package.json
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
    # set up pdfjs and simplecc
    pnpm setup-vendors

    # `tauri-plugin-turso` expects frontend files to exist before the build, else it fails with:
    #
    # > > tauri-plugin-turso-api@0.1.0 build /build/source/apps/readest-app/src-tauri/plugins/tauri-plugin-turso
    # > > true
    # >
    # >   Error Unable to find your web assets, did you forget to build your web app?
    #     Your frontendDist is set to "../out" (which is `/build/source/apps/readest-app/out`).
    pnpm --filter @readest/readest-app build
  '';

  passthru.updateScript = nix-update-script { };

  passthru.tursoPluginDeps = fetchPnpmDeps {
    pname = "tauri-plugin-turso";
    version = finalAttrs.version;
    src = "${finalAttrs.src}/apps/readest-app/src-tauri/plugins/tauri-plugin-turso";
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-quVUYsT3u4UBhuJ75QQ4SEuW8MhGQ0vGhtwtUj/eKHs=";
  };

  passthru.tursoPlugin = stdenv.mkDerivation {
    pname = "tauri-plugin-turso";
    version = finalAttrs.version;
    src = "${finalAttrs.src}/apps/readest-app/src-tauri/plugins/tauri-plugin-turso";

    nativeBuildInputs = [
      pnpm_11
      pnpmConfigHook
      nodejs
    ];

    pnpmDeps = finalAttrs.passthru.tursoPluginDeps;

    buildPhase = ''
      pnpm build
    '';

    installPhase = ''
      cp -r dist-js $out
    '';
  };

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
