{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs_22,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,
  glib-networking,
  openssl,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  libayatana-appindicator,

  aria2,
  deno,
  ffmpeg,
  yt-dlp,
}:
let
  target = stdenv.hostPlatform.rust.rustcTarget;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "firelink";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "nimbold";
    repo = "Firelink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tXNaQ2AxuvONCBKz5IgJicGShui/1TgMyZoLi3g2AOA=";
  };

  cargoHash = "sha256-OkgYW83o4hxZs6JPPcczQ1O+pT6YcEEsWof95aN0Rv0=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-9/3M/d/XOwnKjA2J7vy/C7iVlbFAIbC1y7jZ6/RDduE=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs_22
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking
    openssl
    webkitgtk_4_1
    gtk3
    libsoup_3
    libayatana-appindicator
  ];

  strictDeps = true;
  __structuredAttrs = true;

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  tauriBuildFlags = [
    "--config"
    (builtins.toJSON {
      build.beforeBuildCommand = "";
    })
  ];

  preBuild = ''
    export VITE_BUILD_ID="nixpkgs-firelink-${finalAttrs.version}"
    npm run build

    mkdir -p "src-tauri/engine-dist/${target}"
    ln -s ${lib.getExe aria2} "src-tauri/engine-dist/${target}/aria2c-${target}"
    ln -s ${lib.getExe deno} "src-tauri/engine-dist/${target}/deno-${target}"
    ln -s ${lib.getExe ffmpeg} "src-tauri/engine-dist/${target}/ffmpeg-${target}"
    ln -s ${lib.getExe yt-dlp} "src-tauri/engine-dist/${target}/yt-dlp-${target}"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libayatana-appindicator ]}
    )
  '';

  doCheck = false;

  meta = {
    description = "A fast cross-platform desktop download manager powered by Rust and Tauri";
    homepage = "https://github.com/nimbold/Firelink";
    license = lib.licenses.mit;
    mainProgram = "firelink";
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    platforms = lib.platforms.linux;
  };
})
