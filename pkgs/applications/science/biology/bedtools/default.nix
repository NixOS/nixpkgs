{stdenv, fetchFromGitHub, zlib, python, bzip2, lzma}:

stdenv.mkDerivation rec {
  pname = "bedtools";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = "arq5x";
    repo = "bedtools2";
    rev = "v${version}";
    sha256 = "1266bcn5hgbvysfi6nr4cqxlbxcx7vn7ng8kb0v3gz37qh2zxxw9";
  };

  buildInputs = [ zlib python bzip2 lzma ];
  cc = if stdenv.cc.isClang then "clang++" else "g++";
  buildPhase = "make prefix=$out SHELL=${stdenv.shell} CXX=${cc} -j $NIX_BUILD_CORES";
  installPhase = "make prefix=$out SHELL=${stdenv.shell} CXX=${cc} install";

  meta = with stdenv.lib; {
    description = "A powerful toolset for genome arithmetic.";
    license = licenses.gpl2;
    homepage = https://bedtools.readthedocs.io/en/latest/;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.unix;
  };
}
