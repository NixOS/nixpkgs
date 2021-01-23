{ lib, stdenv
, fetchurl
, bison
, flex
, readline
, libX11
, libICE
, libXaw
, libXmu
, libXext
, libXt
, fftw
}:

stdenv.mkDerivation rec {
  pname = "ngspice";
  version = "33";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    sha256 = "1wa1hmpn13spmxqgbb1m7vgy32mwvjqwrxhymzll8z65q5nbd7dr";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ readline libX11 libICE libXaw libXmu libXext libXt fftw ];

  configureFlags = [ "--enable-x" "--with-x" "--with-readline" "--enable-xspice" "--enable-cider" ];

  meta = with lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = "http://ngspice.sourceforge.net";
    license = with licenses; [ "BSD" gpl2 ];
    maintainers = with maintainers; [ bgamari rongcuid ];
    platforms = platforms.linux;
  };
}
