{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "eigenlayer";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Layr-Labs";
    repo = "eigenlayer-cli";
    rev = "v${version}";
    hash = "sha256-HsDuDe2ANxL+cTJ3mm1enLoKRewZ9Ey/YajpsLO66JA=";
  };

  vendorHash = "sha256-aclRbQtGg6yQMJtaO1WjtHLXU7cE1HX1ZDckRIEtw6o=";

  ldflags = ["-s" "-w"];
  subPackages = ["cmd/eigenlayer"];

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    homepage = "https://www.eigenlayer.xyz/";
    changelog = "https://github.com/Layr-Labs/eigenlayer-cli/releases/tag/${src.rev}";
    description = "Utility that manages core operator functionalities like local keys, operator registration and updates";
    mainProgram = "eigenlayer";
    license = licenses.bsl11;
    maintainers = with maintainers; [selfuryon];
  };
}
