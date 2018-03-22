{ stdenv, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  name = "cni-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "cni";
    rev = "v${version}";
    sha256 = "00ajs2r5r2z3l0vqwxrcwhjfc9px12qbcv5vnvs2mdipvvls1y2y";
  };

  buildInputs = [ go ];

  outputs = ["out" "plugins"];

  buildPhase = ''
    patchShebangs build.sh
    ./build.sh
  '';

  installPhase = ''
    mkdir -p $out/bin $plugins
    mv bin/cnitool $out/bin
    mv bin/* $plugins/
  '';

  meta = with stdenv.lib; {
    description = "Container Network Interface - networking for Linux containers";
    license = licenses.asl20;
    homepage = https://github.com/containernetworking/cni;
    maintainers = with maintainers; [offline];
    platforms = [ "x86_64-linux" ];
  };
}
