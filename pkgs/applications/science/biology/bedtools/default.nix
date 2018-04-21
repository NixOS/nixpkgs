{stdenv, fetchFromGitHub, zlib, python}:

stdenv.mkDerivation rec {
  name = "bedtools-${version}";
  version = "2.27.1";

  src = fetchFromGitHub {
    owner = "arq5x";
    repo = "bedtools2";
    rev = "v${version}";
    sha256 = "1pk68y052rm2m24yfmy82ms8p6kd6xcqxxgi7n0a1sbh89wllm6s";
  };

  buildInputs = [ zlib python ];
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
