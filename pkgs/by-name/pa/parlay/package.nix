{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "parlay";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "parlay";
    rev = "v${version}";
    hash = "sha256-hcNNW4/+AX06vkEbauHyMP5b2y/1YNlWhgqS5Rx8sS8=";
  };

  vendorHash = "sha256-Eo5MgdISiwbaJFg5XHAwe5x3D8GmgzswYmcUG4gvaQk=";

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
