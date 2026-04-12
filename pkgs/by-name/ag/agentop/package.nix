{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "agentop";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "mohitmishra786";
    repo = "agentop";
    rev = "v${version}";
    hash = "sha256-7Wm9Y4M3saVRnRKZlfIlHbL5xTbVBms9BiwvBtblqlY=";
  };

  vendorHash = "sha256-xGmv9sg+MsAR3dpjBr4LlHoLTQig8MsfkwuimJoE/ow=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = {
    description = "Terminal dashboard for AI coding assistant sessions — token usage, cost, and cache efficiency";
    homepage = "https://github.com/mohitmishra786/agentop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "agentop";
  };
}
