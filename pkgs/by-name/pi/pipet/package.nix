{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "pipet";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "pipet";
    rev = version;
    hash = "sha256-NhqrNehmL6LLLEOVT/s2PdQ7HtSCfoM4MST1IHVrJXE=";
  };

  vendorHash = "sha256-jNIjF5jxcpNLAjuWo7OG/Ac4l6NpQNCKzYUgdAoL+C4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.currentSha=${src.rev}"
  ];

  doCheck = false; # Requires network

  meta = {
    homepage = "https://github.com/bjesus/pipet";
    description = "Scraping and extracting data from online assets";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bjesus ];
    mainProgram = "pipet";
  };
}
