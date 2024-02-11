{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "eigenlayer";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "Layr-Labs";
    repo = "eigenlayer-cli";
    rev = "v${version}";
    hash = "sha256-1S/fSb94umtWsPH9R7tCl8wqNPYnJ+E80pnQdheP+CE=";
  };

  vendorHash = "sha256-MWNHoUgnD1V1zeLwoos20eKIUGtFHao/k2yvowInkT0=";

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
