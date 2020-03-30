{ stdenv, fetchFromGitHub, cmake, gmp }:

stdenv.mkDerivation rec {
  pname = "lean";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner  = "leanprover-community";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "0d9lz0mbxyaaykkvk2p8w2hcif9cx0ksihgh7qhxf417bz6msgc1";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ];
  enableParallelBuilding = true;

  preConfigure = ''
    cd src
  '';

  meta = with stdenv.lib; {
    description = "Automatic and interactive theorem prover";
    homepage    = "https://leanprover.github.io/";
    changelog   = "https://github.com/leanprover-community/lean/blob/v${version}/doc/changes.md";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice gebner ];
  };
}

