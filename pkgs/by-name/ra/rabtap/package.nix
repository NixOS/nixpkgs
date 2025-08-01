{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "rabtap";
  version = "1.44.1";

  src = fetchFromGitHub {
    owner = "jandelgado";
    repo = "rabtap";
    rev = "v${version}";
    sha256 = "sha256-mW2O8/22zbA3/wpYkQHCI0z8EEL0Wyud2TD5vNUJrNI=";
  };

  vendorHash = "sha256-Yi4vH3UMOE//p3H9iCR5RY3SjjR0mu2sBRx8WK57Dq8=";

  ldflags = [
    "-X main.BuildVersion=v${version}"
  ];

  meta = with lib; {
    description = "RabbitMQ wire tap and swiss army knife";
    license = licenses.gpl3Only;
    homepage = "https://github.com/jandelgado/rabtap";
    maintainers = with maintainers; [ eigengrau ];
  };
}
