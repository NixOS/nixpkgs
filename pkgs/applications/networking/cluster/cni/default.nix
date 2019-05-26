{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "cni-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "cni";
    rev = "v${version}";
    sha256 = "00ajs2r5r2z3l0vqwxrcwhjfc9px12qbcv5vnvs2mdipvvls1y2y";
  };

  goPackagePath = "github.com/containernetworking/cni";

  buildPhase = ''
    cd "go/src/${goPackagePath}"
    patchShebangs build.sh
    ./build.sh
  '';

  installPhase = ''
    install -Dm555 bin/cnitool $bin/bin/cnitool
  '';

  meta = with stdenv.lib; {
    description = "Container Network Interface - networking for Linux containers";
    license = licenses.asl20;
    homepage = https://github.com/containernetworking/cni;
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = [ "x86_64-linux" ];
  };
}
