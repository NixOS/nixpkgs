{
  rustPlatform,
  lib,
  fetchFromGitHub,
  libsoup,
  pkg-config,
  webkitgtk_4_0,
  openssl,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  gtk3,
  wrapGAppsHook3,
  cargo-tauri,
}:

rustPlatform.buildRustPackage rec {
  pname = "alexandria";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "btpf";
    repo = "Alexandria";
    rev = "refs/tags/v${version}";
    hash = "sha256-NX89Sg639dSwUcUGrpgmdcO4tXl2iszctiRDcBVLbUA=";
    fetchSubmodules = true;
  };

  prePatch = ''
    chmod +w .. # make sure that /build/source is writeable
  '';

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}";
    hash = "sha256-/RGaZMCJftjzvFLp8J/d9+MsxQwe7P0WfISz0JE3fn4=";
  };

  cargoHash = "sha256-W8HCpGuDkq8XfdrSvYfAHyX+oh30/bX29qdclN4P5yo=";

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    webkitgtk_4_0
    gtk3
    libsoup
  ];

  npmRoot = "..";

  sourceRoot = "${src.name}/src-tauri";

  buildAndTestDir = ".";

  meta = {
    homepage = "https://github.com/btpf/Alexandria";
    changelog = "https://github.com/btpf/Alexandria/releases/tag/v${version}";
    description = "Minimalistic cross-platform eBook reader";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "alexandria";
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    license = lib.licenses.gpl3Plus;
  };
}
