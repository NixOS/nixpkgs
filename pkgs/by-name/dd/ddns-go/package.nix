{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "6.10.0";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${version}";
    hash = "sha256-IDz5OuRSJ0fPQ6vvyqrC7DquTI6Ie0XJZxMShHN/Q5A=";
  };

  vendorHash = "sha256-oHiREhvqu14z5StjzD4PgtFasYQ0X435eMCRMiWUzg0=";

  ldflags = [
    "-X main.version=${version}"
  ];

  # network required
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jeessy2/ddns-go";
    description = "Simple and easy to use DDNS";
    license = licenses.mit;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "ddns-go";
  };
}
