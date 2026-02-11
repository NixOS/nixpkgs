{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reindeer";
  version = "2026.02.02.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NiS3TETnyGMGU+AxTNQIem3Cj2/c/VKSXSrcTX/5oME=";
  };

  cargoHash = "sha256-aHAgb3IJVRaVBGd2voUoUblRGoepTjUFIR3WOmTEEVY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ amaanq ];
  };
})
