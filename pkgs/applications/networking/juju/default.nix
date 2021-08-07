{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.9";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-36/fatztop2eB1z9DfnseQXw0Di3Wss72IfgdnKpsNU=";
  };

  vendorSha256 = "sha256-MH9lZNc9KevovZJCN2nClmqJbRSwYoQ4Jb0CXqBBUd0=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
