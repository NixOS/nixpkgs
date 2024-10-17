{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "eigenlayer";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "Layr-Labs";
    repo = "eigenlayer-cli";
    rev = "v${version}";
    hash = "sha256-FvmS9rWmf6bzY5QjVS3otylHYPyQ7KqXVJ0m28/zEi8=";
  };

  vendorHash = "sha256-7KC99PqAPfGnm7yA4nfAlC7V4NhCEYDyPxY7CdOdwno=";

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
