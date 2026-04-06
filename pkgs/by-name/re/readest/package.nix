{
  stdenv,
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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "readest";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "readest";
    repo = "readest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/4UyRzFALujZ98EdXxiVeLH8W+0Mqm09RZ4zEwOVyyk=";
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
    hash = "sha256-7jar0aNXaBfoklGzgvC+1DwsOXgpnOcIcEbIGwWgyfw=";
  };

  cargoRoot = "../..";
  cargoHash = "sha256-rxOjXhXN19w8qAEvELIh0oXuB/N80Dtzmf/i3hjRal0=";

  buildAndTestSubdir = "src-tauri";

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false' \
      --replace-fail '"Readest"' '"readest"'
    jq 'del(.plugins."deep-link")' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
    substituteInPlace src/services/constants.ts \
      --replace-fail "autoCheckUpdates: true" "autoCheckUpdates: false" \
      --replace-fail "telemetryEnabled: true" "telemetryEnabled: false"

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
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-Jf/UaEaLUg/v9ZRInBCEfkDY4d6nwyAIegCMKZe0iAQ=";
  };

  passthru.tursoPlugin = stdenv.mkDerivation {
    pname = "tauri-plugin-turso";
    version = finalAttrs.version;
    src = "${finalAttrs.src}/apps/readest-app/src-tauri/plugins/tauri-plugin-turso";

    nativeBuildInputs = [
      pnpm_10
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
