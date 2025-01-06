{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "morf";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "amrudesh1";
    repo = "morf";
    tag = "v${version}";
    hash = "sha256-3PJ+YtKSH6HHAXBSHO8iMP2HFiuW1RQ0N8iUjQD7NBw=";
  };

  vendorHash = "sha256-tK58UGCI7CuJsFSM7htRQT98tzunAOXyYAxhCkdTJdU=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Offensive mobile security tool designed to identify and address sensitive information";
    homepage = "https://github.com/amrudesh1/morf";
    changelog = "https://github.com/amrudesh1/morf/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "morf";
  };
}
