{ lib, fetchFromGitHub, buildGoPackage, git, which }:
  
buildGoPackage rec {
  pname = "quorum";
  version = "2.5.0";

  goPackagePath = "github.com/jpmorganchase/quorum";

  src = fetchFromGitHub {
    owner = "jpmorganchase";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xfdaqp9bj5dkw12gy19lxj73zh7w80j051xclsvnd41sfah86ll";
  };

  buildInputs = [ git which ];

  buildPhase = ''
    cd "go/src/$goPackagePath"
    make geth bootnode swarm
  '';

  installPhase = ''
    mkdir -pv $bin/bin
    cp -v build/bin/geth build/bin/bootnode build/bin/swarm $bin/bin
  '';

  meta = {
    description = "A permissioned implementation of Ethereum supporting data privacy";
    homepage = "https://www.goquorum.com/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ mmahut ];
  };
}
