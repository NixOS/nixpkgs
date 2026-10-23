{
  lib,
  stdenv,
  callPackage,
  fetchFromForgejo,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_12,
  nodejs-slim,
  rustPlatform,
  cargo,
  rustc,
  binaryen,
  lld,
  wasm-bindgen-cli_0_2_129,
  nix-update-script,
  # noise suppression in calls, the build downloads its model from github
  withDeepfilternet ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "sable-next-unwrapped";
  version = "2.2.2";

  src = fetchFromForgejo {
    domain = "git.sable.moe";
    owner = "SableClient";
    repo = "sable-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vMzTblJ+JvW18fwW6npOPsGJOxroUDP2GSAXUklEbo8=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-zHsBR55ZvMBkmQF8VhTXutbmaQX/6A4z4CMYoMb+tl8=";
  };

  # the rust crates are compiled to wasm for the frontend,
  # sable-desktop reuses them for its native build
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-j5Lvvbf8d2Mo+E4gU/cYCDZUc6zDUzMjjPpkvNHSaXw=";
  };

  postPatch = lib.optionalString withDeepfilternet ''
    cp -r --no-preserve=mode ${finalAttrs.passthru.deepfilternet} static/deepfilternet3
  '';

  nativeBuildInputs = [
    binaryen
    # links the wasm module
    lld
    nodejs-slim
    pnpm_12
    pnpmConfigHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wasm-bindgen-cli_0_2_129
  ];

  env = {
    VITE_APP_VERSION = finalAttrs.version;
    # the stable login redirect schemes, which sable-desktop registers
    SABLE_BUILD_FLAVOR = "stable";
  }
  // lib.optionalAttrs (!withDeepfilternet) {
    SABLE_SKIP_DEEPFILTERNET = "1";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru = {
    deepfilternet = callPackage ./deepfilternet.nix {
      inherit (finalAttrs) src version;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "deepfilternet"
      ];
    };
  };

  meta = {
    description = "Rewrite of the Sable Matrix client in Rust and Svelte";
    homepage = "https://git.sable.moe/SableClient/sable-next";
    changelog = "https://git.sable.moe/SableClient/sable-next/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    sourceProvenance =
      with lib.sourceTypes;
      [ fromSource ] ++ lib.optional withDeepfilternet binaryBytecode;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      fugi
      LashaKamadadze
    ];
  };
})
