{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "starcharts";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "starcharts";
    rev = "v${version}";
    hash = "sha256-RLGKf5+HqJlZUhA5C3cwDumIhlbXcOr5iitI+7GZPBc=";
  };

  vendorHash = "sha256-BlVjGG6dhh7VO9driT0rnpbW6lORojiV+YhrV1Zlj4M=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Plot your repository stars over time";
    mainProgram = "starcharts";
    homepage = "https://github.com/caarlos0/starcharts";
    changelog = "https://github.com/caarlos0/starcharts/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
