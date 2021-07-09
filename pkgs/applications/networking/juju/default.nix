{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.7";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-jGrN0tsLO8gmkyZ1zNYzZd29mCQgLP7lSF0LkOygbyc=";
  };

  vendorSha256 = "sha256-0JNoOSNxJrJkph8OGzgQ7sdslnGC36e3Ap0uMpqriX0=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
