{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "saucectl";
  version = "0.197.1";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "saucelabs";
    repo = "saucectl";
    tag = "v${version}";
    hash = "sha256-Vk09bh8c3NqHVr3FzbgQU2Xxw7J3SPmtvrOv7CFcLXk=";
  };

  ldflags = [
    "-X github.com/saucelabs/saucectl/internal/version.Version=${version}"
    "-X github.com/saucelabs/saucectl/internal/version.GitCommit=${version}"
  ];

  vendorHash = "sha256-n/GblPFolUD+noxGI4yZbOGdAUxM0DXtpCybS+E0k3I=";

  checkFlags = [ "-skip=^TestNewRequestWithContext$" ];

  meta = {
    description = "Command line interface for the Sauce Labs platform";
    changelog = "https://github.com/saucelabs/saucectl/releases/tag/v${version}";
    homepage = "https://github.com/saucelabs/saucectl";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "saucectl";
  };
}
