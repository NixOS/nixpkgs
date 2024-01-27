{ lib, stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation rec {
  pname    = "megahit";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "voutcn";
    repo = "megahit";
    rev = "v${version}";
    sha256 = "1r5d9nkdmgjsbrpj43q9hy3s8jwsabaz3ji561v18hy47v58923c";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isStatic [
    "-DSTATIC_BUILD=ON"
    ];
  meta = with lib; {
    description = "An ultra-fast single-node solution for large and complex metagenomics assembly via succinct de Bruijn graph";
    license     = licenses.gpl3;
    homepage    = "https://github.com/voutcn/megahit";
    maintainers = with maintainers; [ luispedro ];
    platforms = [ "x86_64-linux" ];
  };
}
