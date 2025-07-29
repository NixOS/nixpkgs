{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "6.12.0";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${version}";
    hash = "sha256-6syI3XQNiERqxHUWmquNGHyKHymVkVgD8Yh2iZoek4g=";
  };

  vendorHash = "sha256-0HH5KkMVQzD/xyaue9Sh6CE5dI/aZJMwei7ynhzp9dc=";

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
