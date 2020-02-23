{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "argo";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo";
    rev = "v${version}";
    sha256 = "0q8pvzinpp5ffnl671h38m2i26cyqkpxnhs2kcccvidh3200zia3";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/argoproj/argo";
  subPackages = [ "cmd/argo" ];

  meta = with lib; {
    description = "Container native workflow engine for Kubernetes";
    homepage = https://github.com/argoproj/argo;
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
    platforms = platforms.unix;
  };
}
