{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-libp2p-daemon";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "libp2p";
    repo = "go-libp2p-daemon";
    rev = "v${version}";
    hash = "sha256-N/5V03HQTr7dIvMpIVRlIhEaV2f+aDF36esWMjT96HA=";
  };

  vendorHash = "sha256-WOk06En90ys0pe5OZwhXCJJwry77t13eWg131fnQvpw=";

  doCheck = false;

  meta = with lib; {
    description = "Libp2p-backed daemon wrapping the functionalities of go-libp2p for use in other languages";
    homepage = "https://github.com/libp2p/go-libp2p-daemon";
    license = licenses.mit;
    maintainers = with maintainers; [ fare ];
  };
}
