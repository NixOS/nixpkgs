{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.11";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-KcvlnEfDzwhFzwaWLYuRGa8nh6MkjqZ+u+qJSJZl13U=";
  };

  vendorSha256 = "sha256-0KGeMJDv1BdqM1/uMk+mKpK+Nejz9PiCAfRy96pu3OQ=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
