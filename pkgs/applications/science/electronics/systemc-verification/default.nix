{ stdenv, fetchurl, systemc, coreutils}:

stdenv.mkDerivation rec {
  name = "systemc-verification";
  version = "2.0.1";

  src = fetchurl {
    url    = "https://www.accellera.org/images/downloads/standards/systemc/scv-${version}.tar.gz"; #typo
    sha256 = "7bd1c4037f3c108d02f45cae003d112efdb788d469cb029fada247d330ca4881";
  };

  enableParallelBuilding = true;
  buildInputs = [ systemc ];
  nativeBuildInputs = [ ];

  meta = with stdenv.lib; {
    description = "Provides a common set of APIs that are used as a basis to verification activities with SystemC";
    homepage    = "https://www.accellera.org/activities/working-groups/systemc-verification";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ ratatamatata ];
  };

  configurePhase = ''
    ./configure --with-systemc=${systemc} --prefix=$out
  '';
}