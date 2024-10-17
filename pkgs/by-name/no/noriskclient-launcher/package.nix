{
  lib,
  fetchFromGitHub,

  fetchNpmDeps,
  npmHooks,
  nodejs,

  rustPlatform,
  cargo-tauri,

  pkg-config,
  wrapGAppsHook3,

  openssl,
  libsoup,
  webkitgtk_4_0,
  glib-networking,
}:

rustPlatform.buildRustPackage rec {
  pname = "noriskclient-launcher";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "NoRiskClient";
    repo = "noriskclient-launcher";
    rev = "v${version}";
    hash = "sha256-WaDAP7Oy28QY4wKVXYW82wN1wCT3QhkBXeUoEiSIfME=";
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    inherit src;
    forceGitDeps = true;
    hash = "sha256-Rw8iyvnG0tK5b/tJ5fg5aS7HIvFuDHFRuWSpzAEq8uA=";
  };

  forceGitDeps = true;

  makeCacheWritable = true;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fix-path-env-0.0.0" = "sha256-kSpWO2qMotpsYKJokqUWCUzGGmNOazaREDLjke4/CtE=";
      "tauri-plugin-fs-watch-0.0.0" = "sha256-4Y0Vbd14QWqI3NFcgvfMrXVvGvuA1spXibCXpjHdR9s=";
    };
  };

  cargoRoot = "src-tauri";

  buildAndTestSubdir = cargoRoot;

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs

    cargo-tauri.hook

    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    libsoup
    webkitgtk_4_0
    glib-networking
  ];

  meta = {
    description = "A minecraft client application made using svelte + tauri";
    homepage = "https://norisk.gg";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "noriskclient-launcher";
  };
}
