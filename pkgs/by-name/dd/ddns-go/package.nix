{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "6.7.2";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kfQo86Kii9kL1K5L2vTjw9fo65f4H0ikwUGFaSL/Ck8=";
  };

  vendorHash = "sha256-IkwTi6szNf1Hh50z2jDZsJ2nncvJjnanCsQlrFELpc0=";

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
