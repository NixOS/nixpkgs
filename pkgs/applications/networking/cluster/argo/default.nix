{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "argo";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo";
    rev = "v${version}";
    sha256 = "1f9l9d4r0qfhpr2fn17faczcwmwmdz8f56f27cmmnhxz4r7qcm48";
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
