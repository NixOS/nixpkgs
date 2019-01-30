{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "argo-${version}";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo";
    rev = "v${version}";
    sha256 = "0x3aizwbqkg2712021wcq4chmwjhw2df702wbr6zd2a2cdypwb67";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/argoproj/argo";

  meta = with lib; {
    description = "Container native workflow engine for Kubernetes";
    homepage = https://github.com/argoproj/argo;
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
    platforms = platforms.unix;
  };
}
