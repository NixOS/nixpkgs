{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "pipet";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "pipet";
    rev = version;
    hash = "sha256-PqOx/aFI5gHt78th1nkSKlTGw/r1eU7Ggz5kvtjMCmI=";
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
