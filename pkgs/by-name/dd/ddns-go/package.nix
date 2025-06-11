{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "6.9.5";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${version}";
    hash = "sha256-FwLS233yGPXzBfHscJV4JCNqJru0hOAA808DVis4V0s=";
  };

  vendorHash = "sha256-RPYjw4G1jfsrge1eXKdQ6RdNL7srjagUY14GzXBJvpI=";

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
