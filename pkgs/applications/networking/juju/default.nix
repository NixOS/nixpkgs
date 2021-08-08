{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.10";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-2gCJ6aN6uN0KtOVddLDry4pLhScSh4JHmdsFws59phk=";
  };

  vendorSha256 = "sha256-vFO3Rv+7CLIkl1qS4zp177GmerewfgmyjxEbzdt/RsE=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
