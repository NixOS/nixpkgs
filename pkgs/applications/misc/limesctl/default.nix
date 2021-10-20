{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "limesctl";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fhmGVgJ/4xnf6pe8aXxx1KEmLInxm54my+qgSU4Vc/k=";
  };

  vendorSha256 = "sha256-9MlymY5gM9/K2+7/yTa3WaSIfDJ4gRf33vSCwdIpNqw=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI for Limes";
    homepage = "https://github.com/sapcc/limesctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
