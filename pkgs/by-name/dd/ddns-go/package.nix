{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "6.8.1";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-a8torNtFdBq19a4eb0uMgivtF7FUF1DX6g8kyCc4Gxg=";
  };

  vendorHash = "sha256-D66uremGVcTcyBlCA9vrQM5zGPFR96FqVak6tATEdI0=";

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
