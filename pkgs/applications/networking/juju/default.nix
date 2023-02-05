{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-MZZ4xZpZM/DCc2FFti84E3DZMKOCy2YKZlTnz6FxSOo=";
  };

  vendorHash = "sha256-y9ZcsPY7yKA2Ls72Z3hP3wSOh01y7ZKrebEmxIFhxhU=";

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
