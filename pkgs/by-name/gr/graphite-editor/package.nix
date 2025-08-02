{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,

  binaryen,
  cargo-about,
  cargo-tauri,
  nodejs,
  pkg-config,
  rustc,
  wasm-bindgen-cli_0_2_100,
  wasm-pack,
  wrapGAppsHook4,

  glib,
  gtk3,
  glib-networking,
  libsoup_3,
  openssl,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "graphite-editor";
  version = "0-unstable-2025-06-09";

  src = fetchFromGitHub {
    owner = "GraphiteEditor";
    repo = "Graphite";
    rev = "5c8cd9a927c60c5348c32ac08fd7501c6aabbf05";
    hash = "sha256-TRNifCuuAVSWohQLO8PjLlI4uwdHLtQu4Cc5BW1ZijI=";
  };

  env.npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    src = "${finalAttrs.src}/frontend";
    hash = "sha256-XXD04aIPasjHtdOE/mcQ7TocRlSfzHGLiYNFWOPHVrM=";
  };

  buildAndTestSubdir = "frontend/src-tauri";

  cargoHash = "sha256-ni2cHhGv5CVIP+mB56bZFWAA1qUjb8G7pd0+9FcujeA=";

  nativeBuildInputs = [
    pkg-config
    cargo-tauri.hook
    rustc.llvmPackages.lld
    wasm-bindgen-cli_0_2_100
    wrapGAppsHook4

    # frontend/ui
    cargo-about
    binaryen # wasm-opt
    rustc # cargo metadata
    nodejs
    wasm-pack
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib # gio-2.0
    glib-networking # networking required to fetch fonts remotely
    gtk3 # gdk-3.0
    libsoup_3 # libsoup-3.0
    openssl
    webkitgtk_4_1 # javascriptcoregtk-4.1 webkit2gtk-4.1
  ];

  postPatch = ''
    (
      local postPatchHooks=() # written to by npmConfigHook
      source ${npmHooks.npmConfigHook}/nix-support/setup-hook
      npmRoot=frontend npmDeps=$npmDeps npmConfigHook
    )
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
    (
      cd frontend
      npm run build
    )
  '';

  meta = {
    description = "2D vector & raster editor that melds traditional layers & tools with a modern node-based, non-destructive, procedural workflow";
    homepage = "https://github.com/GraphiteEditor/Graphite";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jk ];
    mainProgram = "Graphite";
  };
})
