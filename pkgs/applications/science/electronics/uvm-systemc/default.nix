{ stdenv, fetchurl, systemc, coreutils}:

stdenv.mkDerivation rec {
  name = "uvm-systemc";
  version = "1.0-beta3";

  src = fetchurl {
    url    = "https://www.accellera.org/images/downloads/drafts-review/uvm-systemc-10-beta3tar.gz"; #typo
    sha256 = "0h8hf2wvdc74ypm3jjh12nbr6cxrv5q68x3ixl35p993ldw7s6w0";
  };

  enableParallelBuilding = true;
  buildInputs = [ systemc ];
  nativeBuildInputs = [ ];

  meta = with stdenv.lib; {
    description = "New standard to develop structured verification environments following the Universal Verification Methodology (UVM)";
    homepage    = "https://www.accellera.org/activities/working-groups/systemc-verification";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ ratatamatata ];
  };

  unpackPhase = ''
    tar -xf ${src}
    cd uvm-systemc-1.0-beta3
    sed -i 's/systemc-2.3.1/systemc-2.3.3/g' ./configure
  '';

  SYSTEMC_INCLUDE="${systemc}/include";
  SYSTEMC_LIBS="${systemc}/lib-linux64";
  SYSTEMC_HOME="${systemc}";
}
