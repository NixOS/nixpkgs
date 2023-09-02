{ lib, 
  stdenv, 
  fetchgit,
  cmake, 
  bison, 
  flex, 
  gmp
}:

stdenv.mkDerivation rec {
  pname = "RAxML-NG";
  version = "1.2.0";

  src = fetchgit {
    url = "https://github.com/amkozlov/raxml-ng.git"; 
    rev = version;
    hash = "sha256-JoVtX4RjMw3ON9iFUzAcJqXj2LD8V3sFZTPZfOIG0iQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [bison flex gmp ];

  configurePhase = ''
    mkdir build && cd build
    cmake ..
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bin/raxml-ng $out/bin
  '';

  meta = with lib; {
    description = "A phylogenetic tree inference tool which uses maximum-likelihood (ML) optimality criterion.";
    license = licenses.gpl3;
    homepage = "https://github.com/amkozlov/raxml-ng";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    maintainers = [ maintainers.egorlappo ];
  };
}
