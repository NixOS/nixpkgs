{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "6.14.0";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${version}";
    hash = "sha256-jx9Mvb40lDWxZp47fbHs0M+f8VQCBnzHb0bQiLRby1M=";
  };

  vendorHash = "sha256-CtbbyI7sL1Ej4WDWkEZoRFngiwWpzSwvAKAWQwiMD1E=";

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
