{
  lib,
  stdenv,
  fetchFromForgejo,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  pnpm_12,
  nodejs-slim,
  rustPlatform,
  cargo,
  rustc,
  binaryen,
  lld,
  wasm-bindgen-cli_0_2_130,
  llvmPackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "sable-next-unwrapped";
  version = "26.11.3";

  src = fetchFromForgejo {
    domain = "git.sable.moe";
    owner = "SableClient";
    repo = "sable-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ris5iIygXBbVVxp1VwvWrxeAeodYiZz+dOYPoYIXnf4=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-oCF8B2mrzt25/Qgjnqlf0amy7xGV31xiUlYLRm9HxEA=";
  };

  # the rust crates are compiled to wasm for the frontend,
  # sable-desktop reuses them for its native build
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ZQLIkQQYEeh/dTRp0O8HIcJrYL1EKDDYtgyZJGPmnpI=";
  };

  nativeBuildInputs = [
    binaryen
    # links the wasm module
    lld
    nodejs-slim
    pnpm_12
    pnpmConfigHook
    pnpmBuildHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wasm-bindgen-cli_0_2_130
  ];

  env = {
    # C code in the rust dependencies is compiled for wasm too, which needs a compiler and archiver that target it
    CC_wasm32_unknown_unknown = lib.getExe llvmPackages.clang-unwrapped;
    AR_wasm32_unknown_unknown = lib.getExe' llvmPackages.bintools-unwrapped "llvm-ar";
    VITE_APP_VERSION = finalAttrs.version;
    # the stable login redirect schemes, which sable-desktop registers
    SABLE_BUILD_FLAVOR = "stable";
    # no sourcemaps, they're about a third of the output and only useful with sentry
    SABLE_FOSS = "1";
  };

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Matrix web client with a Rust core and a Svelte interface";
    homepage = "https://git.sable.moe/SableClient/sable-next";
    changelog = "https://git.sable.moe/SableClient/sable-next/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license =
      with lib.licenses;
      AND [
        agpl3Plus
        cc-by-40
      ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      fugi
      lashakamadadze
    ];
  };
})
