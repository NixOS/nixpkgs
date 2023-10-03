{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-sUlM4bLy/kluZmGOzMACz92GG46XYKicNPP5k2FPSGA=";
  };

  vendorHash = "sha256-mPEixXVuxAqgkBoNqIYnZaFJynHJsnmamaHqyh/svwQ=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  subPackages = [
    "cmd/juju"
  ];

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
