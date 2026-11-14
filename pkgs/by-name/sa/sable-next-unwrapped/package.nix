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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "sable-next-unwrapped";
  version = "2.3.8";

  src = fetchFromForgejo {
    domain = "git.sable.moe";
    owner = "SableClient";
    repo = "sable-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bCb1vN9LkwkuAjshp6Gq6cibMSUXl6ltzpVThlcrE+s=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-1tgo7mxHHz2J5BT3NCSKONZIhwg5ouyZbtv5vBkhRn8=";
  };

  # the rust crates are compiled to wasm for the frontend,
  # sable-desktop reuses them for its native build
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-BAg6nljjuDaIAXhplI0vFBX1h4eJCR72vo0CIUlTeY8=";
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
    description = "Rewrite of the Sable Matrix client in Rust and Svelte";
    homepage = "https://git.sable.moe/SableClient/sable-next";
    changelog = "https://git.sable.moe/SableClient/sable-next/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      fugi
      lashakamadadze
    ];
  };
})
