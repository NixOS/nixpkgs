{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.31";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-vRe7H7wtZUTsAJa6QVP+BTDDkJsfgIlBVpGcvtU1e0g=";
  };

  vendorSha256 = "sha256-Tx5RazLrNZ5GMRu4/jKhuNN7m1mQw4V7TBcIed/Gssg=";

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
