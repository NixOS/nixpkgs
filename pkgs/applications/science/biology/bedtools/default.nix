{stdenv, fetchFromGitHub, zlib, python, bzip2, lzma}:

stdenv.mkDerivation rec {
  pname = "bedtools";
  version = "2.29.1";

  src = fetchFromGitHub {
    owner = "arq5x";
    repo = "bedtools2";
    rev = "v${version}";
    sha256 = "1vbpjvzl4ppzkan9qgm84bkn9kl3h3m5xz92y18wn1sksxcdq50x";
  };

  buildInputs = [ zlib python bzip2 lzma ];
  cxx = if stdenv.cc.isClang then "clang++" else "g++";
  cc = if stdenv.cc.isClang then "clang" else "gcc";
  buildPhase = "make prefix=$out SHELL=${stdenv.shell} CXX=${cxx} CC=${cc} -j $NIX_BUILD_CORES";
  installPhase = "make prefix=$out SHELL=${stdenv.shell} CXX=${cxx} CC=${cc} install";

  meta = with stdenv.lib; {
    description = "A powerful toolset for genome arithmetic.";
    license = licenses.gpl2;
    homepage = https://bedtools.readthedocs.io/en/latest/;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.unix;
  };
}
