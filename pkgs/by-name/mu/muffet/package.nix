{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.10.6";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-9dra/LhtSIWN2pjNEJMITz/GzyWRtXTyQBqBxRhjARc=";
  };

  vendorHash = "sha256-MYU8zgqI05oBep/dehs59S3JcrThrgLEzIgrIr/Tr4Y=";

  meta = with lib; {
    description = "Website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "muffet";
  };
}
