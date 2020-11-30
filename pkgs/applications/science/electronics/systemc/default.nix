{ stdenv, lib, fetchurl}:

stdenv.mkDerivation rec {
  pname = "systemc";
  version = "2.3.3";

  src = fetchurl {
    url    = "https://www.accellera.org/images/downloads/standards/${pname}/${pname}-${version}.tar.gz";
    sha256 = "5781b9a351e5afedabc37d145e5f7edec08f3fd5de00ffeb8fa1f3086b1f7b3f";
  };

  enableParallelBuilding = true;
  buildInputs = [];
  nativeBuildInputs = [];

  meta = with lib; {
    description = "Set of C++ classes and macros which provide an event-driven simulation interface. ";
    homepage    = "https://www.accellera.org/activities/working-groups/systemc-language";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ ratatamatata ];
  };
}