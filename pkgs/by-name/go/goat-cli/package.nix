{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "goat-cli";
  version = "1.4.0";

  src = fetchFromGitHub {
    repo = "goat";
    owner = "studio-b12";
    rev = "v${version}";
    hash = "sha256-7inoRBVR7zmt0jUFAGYjoYT2cdda0qgzyXLL+GiBFMg=";
  };

  vendorHash = "sha256-b/v27pHA9LcFe4TC/EpelJVSkAg4sq7b8p2gk0bWsQc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/studio-b12/goat/internal/version.Version=${version}"
    "-X github.com/studio-b12/goat/internal/version.CommitHash=${src.rev}"
  ];

  patches = [
    ./mock-fix.patch
  ];

  # Checks currently fail because of an issue with github.com/studio-b12/goat/mocks
  doCheck = false;

  meta = {
    description = "Integration testing tool for HTTP APIs using a simple script language";
    homepage = "https://studio-b12.github.io/goat/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "goat";
  };

}
