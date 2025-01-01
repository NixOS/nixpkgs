{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ktor-cli";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ktorio";
    repo = "ktor-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-rIXyLqXEfbw0YR8+0N5XyntsB8H0D5DvJTneatuC48s=";
  };

  subPackages = "cmd/ktor";

  vendorHash = "sha256-gu/tuQPScSN0qsNd3fz/tz1ck6OGj/lupnNd/xLJxmk=";

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
