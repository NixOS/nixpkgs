{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "systemc";
  version = "2.3.3";

  src = fetchurl {
    url = "https://www.accellera.org/images/downloads/standards/systemc/${pname}-${version}.tar.gz";
    sha256 = "5781b9a351e5afedabc37d145e5f7edec08f3fd5de00ffeb8fa1f3086b1f7b3f";
  };

  meta = with lib; {
    description = "The language for System-level design, modeling and verification";
    homepage    = "https://systemc.org/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ victormignot ];
  };
}
