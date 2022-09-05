{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.33";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-BK5fTPV4glBg4a4QI5L3ZBmWYGrfLDx6hAOzlNbMxJU=";
  };

  vendorSha256 = "sha256-xBlGqHmAX08LlHmZ9Vr+j06Cf2soIPDFJKZh36ku8cw=";

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
