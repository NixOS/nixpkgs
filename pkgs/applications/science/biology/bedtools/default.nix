{stdenv, fetchFromGitHub, zlib, python, bzip2, lzma}:

stdenv.mkDerivation rec {
  pname = "bedtools";
  version = "2.29.0";

  src = fetchFromGitHub {
    owner = "arq5x";
    repo = "bedtools2";
    rev = "v${version}";
    sha256 = "0d6i985qqxp92ddq4n6558m70qi5rqhl724wrfys0hm0p6a9h56x";
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
