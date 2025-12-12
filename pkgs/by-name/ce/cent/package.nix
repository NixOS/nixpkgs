{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cent";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "xm1k3";
    repo = "cent";
    tag = "v${version}";
    hash = "sha256-AmOq+n+TcpwDgFjFsFNVl/fAIAJbqYdoR2P1dasb8h8=";
  };

  vendorHash = "sha256-sn4ZIDP07u9dwVJHy7KrQFZHsGrqpkM8CzcIbNMDiIo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to handle Nuclei community templates";
    homepage = "https://github.com/xm1k3/cent";
    changelog = "https://github.com/xm1k3/cent/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "cent";
  };
}
