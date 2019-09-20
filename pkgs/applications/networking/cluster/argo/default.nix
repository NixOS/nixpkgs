{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "argo";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo";
    rev = "v${version}";
    sha256 = "1m6d3z2fxw447zvm7v9yrmv1nys7051bn0scwgbwhk2vl81xyar6";
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
