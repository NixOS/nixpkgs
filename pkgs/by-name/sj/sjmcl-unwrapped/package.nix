{
  lib,
  stdenv,
  cargo-tauri,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sjmcl-unwrapped";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "UNIkeEN";
    repo = "SJMCL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cwZRQjSo5lzSjX2lpLhcSuvdiTLhMTcXQhnk340+0yY=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-r4W4gjx0Y8o7iR1ififDATgZmpXhNRksgkCLd8iOJXI=";
  };

  cargoHash = "sha256-jUebQ3uIoe7mT8fRqEsofq1sxT8EBRB3CUJ2Ac6XEt8=";
  cargoRoot = "src-tauri";

  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoTestFlags = [
    # skip doctests (doc examples are not compilable code)
    "--lib"
    "--bins"
    "--tests"
  ];

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  meta = {
    description = "Open source Minecraft launcher designed by SJTU Minecraft Club";
    homepage = "https://mc.sjtu.cn/sjmcl";
    changelog = "https://github.com/UNIkeEN/SJMCL/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mx6436 ];
    mainProgram = "SJMCL";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
