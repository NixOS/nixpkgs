{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "argo";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo";
    rev = "v${version}";
    sha256 = "15726n5rrbzszq5dpmrxbw9cn7ahihn28jqk274270140gz5aak1";
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
