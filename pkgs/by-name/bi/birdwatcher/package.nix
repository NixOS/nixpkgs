{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  nix-update-script,
}:

buildGoModule rec {
  pname = "birdwatcher";
  version = "2.2.5";

  vendorHash = "sha256-NTD2pnA/GeTn4tXtIFJ227qjRtvBFCjWYZv59Rumc74=";

  src = fetchFromGitHub {
    owner = "alice-lg";
    repo = "birdwatcher";
    rev = version;
    hash = "sha256-TTU5TYWD/KSh/orDdQnNrQJ/G7z5suBu7psF9V6AAIw=";
  };

  deleteVendor = true;

  passthru = {
    tests = {
      inherit (nixosTests) birdwatcher;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/alice-lg/birdwatcher";
    description = "Small HTTP server meant to provide an API defined by Barry O'Donovan's birds-eye to the BIRD internet routing daemon";
    changelog = "https://github.com/alice-lg/birdwatcher/blob/master/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ stv0g ];
    mainProgram = "birdwatcher";
  };
}
