{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.26";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-phzjjW9KG0Z5WAzxtYdI7i2Nw4FHVNeEJswQreHga4M=";
  };

  vendorSha256 = "sha256-Jzd6I3a/2Un2a3/T2vzFuHwe9Y3eGEvfpZWSwjWokM0=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
