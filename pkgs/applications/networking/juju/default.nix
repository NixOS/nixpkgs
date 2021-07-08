{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.5";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-oBwusx63a8AWNHqlNtG0S/SiIRM55fbc/CGN2MFJDYA=";
  };

  vendorSha256 = "sha256-VHUDqDsfY0c6r5sJbMX7JcXTIBXze9cd5qHqZWZAC2g=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
