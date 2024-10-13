{ lib
, buildGoModule
, fetchFromGitHub
, testers
, patch2pr
}:

buildGoModule rec {
  pname = "patch2pr";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "bluekeyes";
    repo = "patch2pr";
    rev = "v${version}";
    hash = "sha256-Pr2h5iezn//oyvuUoq5B49wEL1cUXOHhHjR3ylMXowQ=";
  };

  vendorHash = "sha256-6w49XQNElSHpOamEZNpvvr67vYrZYXy2Sm7dWMh6OiU=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  passthru.tests.patch2pr-version = testers.testVersion {
    package = patch2pr;
    command = "${patch2pr.meta.mainProgram} --version";
    version = version;
  };

  meta = with lib; {
    description = "Create pull requests from patches without cloning the repository";
    homepage = "https://github.com/bluekeyes/patch2pr";
    changelog = "https://github.com/bluekeyes/patch2pr/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ katrinafyi ];
    mainProgram = "patch2pr";
  };
}
