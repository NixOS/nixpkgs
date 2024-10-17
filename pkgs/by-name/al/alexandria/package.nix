{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  webkitgtk,
  openssl,
  libclang,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  wrapGAppsHook4,
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
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
    webkitgtk
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
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
}
