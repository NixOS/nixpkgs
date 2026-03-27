{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "starcharts";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "starcharts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RLGKf5+HqJlZUhA5C3cwDumIhlbXcOr5iitI+7GZPBc=";
  };

  vendorHash = "sha256-BlVjGG6dhh7VO9driT0rnpbW6lORojiV+YhrV1Zlj4M=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Plot your repository stars over time";
    mainProgram = "starcharts";
    homepage = "https://github.com/caarlos0/starcharts";
    changelog = "https://github.com/caarlos0/starcharts/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
