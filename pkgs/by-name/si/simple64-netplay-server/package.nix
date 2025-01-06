{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "simple64-netplay-server";
  version = "2024.12.3";

  src = fetchFromGitHub {
    owner = "simple64";
    repo = "simple64-netplay-server";
    tag = "v${version}";
    hash = "sha256-u5KiP9O5wyNuYP1EdWs1xSEaz0Ey9dI9nX+YiavaEdw=";
  };

  vendorHash = "sha256-1gySXbp1N0lnWToVQU3N9zQxl9Z0e9ICCeAIKwSoxaY=";

  meta = {
    description = "Dedicated server for simple64 netplay";
    homepage = "https://github.com/simple64/simple64-netplay-server";
    license = lib.licenses.gpl3Only;
    mainProgram = "simple64-netplay-server";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
