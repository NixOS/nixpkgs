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
  targetTriple = stdenv.hostPlatform.rust.rustcTarget;
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

    mkdir -p "src-tauri/engine-dist/${targetTriple}"
    ln -s "${aria2}/bin/aria2c" "src-tauri/engine-dist/${targetTriple}/aria2c-${targetTriple}"
    ln -s "${deno}/bin/deno" "src-tauri/engine-dist/${targetTriple}/deno-${targetTriple}"
    ln -s "${ffmpeg}/bin/ffmpeg" "src-tauri/engine-dist/${targetTriple}/ffmpeg-${targetTriple}"
    ln -s "${yt-dlp}/bin/yt-dlp" "src-tauri/engine-dist/${targetTriple}/yt-dlp-${targetTriple}"
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
    maintainers = [ lib.maintainers.aliheidary1381 ];
    platforms = lib.platforms.linux;
  };
})
