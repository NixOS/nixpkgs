{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ktor-cli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ktorio";
    repo = "ktor-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-Q2k5U7lP3kyQu0l4qU1jdq6j0SZ97ZFJF4gAneQ2ess=";
  };

  subPackages = "cmd/ktor";

  vendorHash = "sha256-gu/tuQPScSN0qsNd3fz/tz1ck6OGj/lupnNd/xLJxmk=";

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "Command-line tool for creating Ktor projects";
    homepage = "https://github.com/ktorio/ktor-cli";
    changelog = "https://github.com/ktorio/ktor-cli/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ nartsiss ];
    mainProgram = "ktor";
  };
}
