{stdenv, fetchurl, gperf, flex, bison}:

stdenv.mkDerivation rec {
  name = "verilog-0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/iverilog/${name}.tar.gz";
    sha256 = "dd68c8ab874a93805d1e93fa76ee1e91fc0c7b20822ded3e57b6536cd8c0d1ba";
  };

  buildInputs = [ gperf flex bison ];

  meta = {
    description = "Icarus Verilog compiler";
    homepage = http://www.icarus.com;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [winden];
    platforms = with stdenv.lib.platforms; linux;
  };
}
