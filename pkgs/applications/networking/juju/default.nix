{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.17";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-USpPu50mlg/X4M0ewQrNHdzNn3GMixDJzVqAXrmPbPg=";
  };

  vendorSha256 = "sha256-EzZEfS/JpdKrtwmGL57pz5EH20XRnYhNl7sZKN7sdQ4=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
