{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "parlay";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "parlay";
    rev = "v${version}";
    hash = "sha256-rpzCwbF2M6zfNVHLaSPgX30ti+XtJ645HqoDJvx8lg8=";
  };

  vendorHash = "sha256-kxN2uBXjCnyVbypDOrOAXoSa6Pb7Fmk487ael4aI9Uw=";

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
}
