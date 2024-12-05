{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ktor-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ktorio";
    repo = "ktor-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-6KPi7CntJjzKfpOgHlGOv20ifIu+FT63dLeq+ko4jMc=";
  };

  subPackages = "cmd/ktor";

  vendorHash = "sha256-ITYNSq2hs0QcOZZShkwtjZVcSyGY1uCmhgoZ0l9nPP0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = {
    description = "Command-line tool for creating Ktor projects";
    homepage = "https://github.com/ktorio/ktor-cli";
    changelog = "https://github.com/ktorio/ktor-cli/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "ktor";
  };
}
