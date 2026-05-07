{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "parlay";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "parlay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bLukosGqyRnvQ4fwntE2lV7VbQNY5MDIfaX/WXBfTuA=";
  };

  vendorHash = "sha256-X/cgNdsUG0Ics/DCk1HOdzez9Ewwm1odFL1EiyFv1Sw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Enriches SBOMs with data from third party services";
    homepage = "https://github.com/snyk/parlay";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kiike
    ];
    mainProgram = "parlay";
    platforms = lib.platforms.unix;
  };
})
