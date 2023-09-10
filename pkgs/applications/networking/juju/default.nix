{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-ZmMOQCKQWtzB2O6CNZTRhhj7gkpRRXY9ILN2KdSQoWk=";
  };

  vendorHash = "sha256-rqf5nAXwcW6lm7sidEcxMqatT4KPju4Seo1/Awse5Zs=";

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
