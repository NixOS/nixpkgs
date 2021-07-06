{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-ZiG+LMeQboFxaLIBSHjRNe5tt8bEguYXQp3nhkoMpek=";
  };

  vendorSha256 = "sha256-5R3TmwOzHgdEQhS4B4Bb0InghaEhUVxDSl7oZl3aNZ4=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
