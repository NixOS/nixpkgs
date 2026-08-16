{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stardust-xr-flatland";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "flatland";
    tag = finalAttrs.version;
    hash = "sha256-Gp2r6PJiyNb+augDwS/vGPJfwb5U6pVYgSyhS9QlggY=";
  };

  patches = [ ./fix-reify-test-signature.patch ];

  env.STARDUST_RES_PREFIXES = "${finalAttrs.src}/res";

  cargoHash = "sha256-2LT/Szwzs83Poe7BojmUFh9yyUEhSgHmBR5QaO/BE4g=";

  __structuredAttrs = true;
  strictDeps = true;

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
