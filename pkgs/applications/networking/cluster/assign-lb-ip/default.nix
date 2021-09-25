{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "assign-lb-ip";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Nordix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PkMXjFP2brULCnD6mGz9wCufMpiwsmulDpINiwmkeys=";
  };

  vendorSha256 = "sha256-j9SweQq45sYk0lH6zkFrmWRlVhhMO8rLJGQxS6smAVw=";

  meta = with lib; {
    description = "Assigns loadBalancerIP address to a Kubernetes service for testing purposes";
    homepage    = "https://github.com/Nordix/assign-lb-ip";
    license     = licenses.asl20;
    maintainers = [ maintainers.starcraft66 ];
  };
}
