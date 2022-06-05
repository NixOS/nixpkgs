{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.27";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-4G+veQkPY6n/uRMsBWQgig/6IDc0Y2nXDpMUyC1ShF4=";
  };

  vendorSha256 = "sha256-Ieaf+Qp/7/6nv2ftHY3pbtOg+t7dYAuMv4BvhRaAZ9E=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
