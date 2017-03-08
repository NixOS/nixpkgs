{stdenv, fetchFromGitHub, zlib, python}:

stdenv.mkDerivation rec {
  name = "bedtools-${version}";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "arq5x";
    repo = "bedtools2";
    rev = "v${version}";
    sha256 = "1j2ia68rmcw3qksjm5gvv1cb84bh76vmln59mvncr2an23f5a3ss";
  };

  buildInputs = [ zlib python ];
  buildPhase = "make prefix=$out SHELL=${stdenv.shell} -j $NIX_BUILD_CORES";
  installPhase = "make prefix=$out SHELL=${stdenv.shell} install";

  meta = with stdenv.lib; {
    description = "A powerful toolset for genome arithmetic.";
    license = licenses.gpl2;
    homepage = https://bedtools.readthedocs.io/en/latest/;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.unix;
  };
}
