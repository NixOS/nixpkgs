{ stdenv, fetchurl, perl }:

stdenv.mkDerivation {
  name = "dvb-apps-7f68f9c8d311";

  src = fetchurl {
    url = "https://linuxtv.org/hg/dvb-apps/archive/7f68f9c8d311.tar.gz";
    sha256 = "0a6c5jjq6ad98bj0r954l3n7zjb2syw9m19jksg06z4zg1z8yg82";
  };

  buildInputs = [ perl ];

  dontConfigure = true; # skip configure

  installPhase = "make prefix=$out install";

  meta = {
    description = "Linux DVB API applications and utilities";
    homepage = https://linuxtv.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    broken = true; # 2018-04-10
  };
}
