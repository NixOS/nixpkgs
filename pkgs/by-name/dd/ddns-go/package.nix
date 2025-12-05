{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "6.13.3";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${version}";
    hash = "sha256-kB13TjZpeLnrbLc4dhA7lJY4I24wjTGfeqFtt97pyQE=";
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
