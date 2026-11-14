{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stardust-xr-flatland";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "flatland";
    tag = finalAttrs.version;
    hash = "sha256-vr0rAHyykVmKg6a7D2PGaQAu8FmgI2lgpmaFEwpvpxg=";
  };

  patches = [ ./fix-reify-test-signature.patch ];

  env.STARDUST_RES_PREFIXES = "${finalAttrs.src}/res";

  cargoHash = "sha256-iNvDxgRjvyql76064MQtTDxXiG6rlqBpCVkQB2nqUQU=";

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flat window for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "flatland";
    teams = with lib.teams; [ stardust-xr ];
    platforms = lib.platforms.unix;
  };
})
