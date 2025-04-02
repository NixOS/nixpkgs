{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "rabtap";
  version = "99.9.9";

  src = fetchFromGitHub {
    owner = "jandelgado";
    repo = "rabtap";
    rev = "v${version}";
    sha256 = "sha256-KAtIEtJdDLBXb3dHUgA7I97z2p99HjB+NYyUyOgoTnw=";
  };

  vendorHash = "sha256-Yi4vH3UMOE//p3H9iCR5RY3SjjR0mu2sBRx8WK57Dq8=";

  meta = with lib; {
    description = "RabbitMQ wire tap and swiss army knife";
    license = licenses.gpl3Only;
    homepage = "https://github.com/jandelgado/rabtap";
    maintainers = with maintainers; [ eigengrau ];
  };
}
