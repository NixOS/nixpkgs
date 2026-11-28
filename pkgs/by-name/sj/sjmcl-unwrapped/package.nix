{
  lib,
  stdenv,
  cargo-tauri,
  fetchFromGitHub,
  nodejs,
  pnpm_12,
  pnpm ? pnpm_12,
  pnpmConfigHook,
  pnpmBuildHook,
  fetchPnpmDeps,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sjmcl-unwrapped";
  version = "1.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "UNIkeEN";
    repo = "SJMCL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WiIJfsJXvLsFc8bw7bJ4Gm93Bkt/vaveLbD4NKdbkY8=";
  };

  cargoHash = "sha256-75dJmHXWBW88OHPvc8iSrYiLVyC49ARwzu7APMpxFGk=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoTestFlags = [
    "--lib"
    "--bins"
    "--tests"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-3AeIVZQN3bgnEshF6tnYDXbmLSyXDOwUSN32mEXOi7g=";
  };

  dontPnpmBuild = true;

  nativeBuildInputs = [
    pnpm
    pnpmConfigHook
    pnpmBuildHook
    nodejs

    cargo-tauri.hook

    pkg-config
  ];

  buildInputs = [ sqlite ] ++ lib.optionals stdenv.hostPlatform.isLinux [ webkitgtk_4_1 ];

  meta = {
    description = "Open source Minecraft launcher designed by SJTU Minecraft Club";
    homepage = "https://mc.sjtu.cn/sjmcl";
    changelog = "https://github.com/UNIkeEN/SJMCL/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "SJMCL";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
