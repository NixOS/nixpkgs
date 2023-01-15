{ lib, fetchFromGitHub, buildGoPackage, git, which, removeReferencesTo, go }:

buildGoPackage rec {
  pname = "quorum";
  version = "22.7.5";

  goPackagePath = "github.com/consensys/quorum";

  src = fetchFromGitHub {
    owner = "ConsenSys";
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
    mkdir -pv $out/bin
    cp -v build/bin/geth build/bin/bootnode build/bin/swarm $out/bin
  '';

  # fails with `GOFLAGS=-trimpath`
  allowGoReference = true;
  preFixup = ''
    find $out -type f -exec ${removeReferencesTo}/bin/remove-references-to -t ${go} '{}' +
  '';

  meta = with lib; {
    description = "A permissioned implementation of Ethereum supporting data privacy";
    homepage = "https://www.goquorum.com/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ mmahut ];
    platforms = subtractLists ["aarch64-linux"] platforms.linux;
  };
}
