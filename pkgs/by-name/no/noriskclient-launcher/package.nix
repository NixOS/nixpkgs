{
  lib,
  fetchFromGitHub,

  fetchNpmDeps,
  npmHooks,
  nodejs,

  rustPlatform,
  cargo-tauri_1,

  pkg-config,
  wrapGAppsHook3,

  openssl,
  libsoup_2_4,
  webkitgtk_4_0,
  glib-networking,
}:

rustPlatform.buildRustPackage rec {
  pname = "noriskclient-launcher";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "NoRiskClient";
    repo = "noriskclient-launcher";
    rev = "refs/tags/v${version}";
    hash = "sha256-nM8yO7UYpSN8iC8DWbpUmrQHTERiqve2AwUt0w/bOTk=";
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    inherit src;
    forceGitDeps = true;
    hash = "sha256-tk/pZlub+rRDgEB51FA+MmXl6ihoFqBXGc8GaLP8Hu4=";
  };

  forceGitDeps = true;

  makeCacheWritable = true;

  cargoRoot = "src-tauri";

  useFetchCargoVendor = true;
  cargoHash = "sha256-rm0s4GD+aSI9ilfY+8yrR1uuiNC1C9P7BnaEnCCTBQQ=";

  buildAndTestSubdir = cargoRoot;

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs

    cargo-tauri_1.hook

    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    libsoup_2_4
    webkitgtk_4_0
    glib-networking
  ];

  meta = {
    description = "Minecraft client application made using svelte + tauri";
    homepage = "https://norisk.gg";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "no-risk-client";
  };
}
