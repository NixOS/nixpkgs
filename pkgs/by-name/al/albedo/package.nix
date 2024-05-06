{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "albedo";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "coreruleset";
    repo = "albedo";
    rev = "refs/tags/v${version}";
    hash = "sha256-HMW0SIcPDCy2QNfxpMke+/d1XCNpyx6RL6RCZAmU+WE=";
  };

  vendorHash = "sha256-3YBcu/GEonEoORbB7x6YGpIl7kEzUQ9PAZNFB8NKb+c=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "HTTP reflector and black hole";
    homepage = "https://github.com/coreruleset/albedo";
    changelog = "https://github.com/coreruleset/albedo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "albedo";
  };
}
