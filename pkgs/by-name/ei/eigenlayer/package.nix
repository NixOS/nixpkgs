{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "eigenlayer";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "Layr-Labs";
    repo = "eigenlayer-cli";
    rev = "v${version}";
    hash = "sha256-8HCoUZHRma4dIIZvIFRkXJl7r73j2stn6fuUj/cQ16g=";
  };

  vendorHash = "sha256-gFWUxC2pTMx3QVbIkqpCrsA2ZTQpal89pEJv11uCMJ8=";

  ldflags = [
    "-s"
    "-w"
  ];
  subPackages = [ "cmd/eigenlayer" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://www.eigenlayer.xyz/";
    changelog = "https://github.com/Layr-Labs/eigenlayer-cli/releases/tag/${src.rev}";
    description = "Utility that manages core operator functionalities like local keys, operator registration and updates";
    mainProgram = "eigenlayer";
    license = licenses.bsl11;
    maintainers = with maintainers; [ selfuryon ];
  };
}
