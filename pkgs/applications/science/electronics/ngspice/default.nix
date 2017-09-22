{stdenv, fetchurl, readline, bison, flex, libX11, libICE, libXaw, libXext}:

stdenv.mkDerivation {
  name = "ngspice-26";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-26.tar.gz";
    sha256 = "51e230c8b720802d93747bc580c0a29d1fb530f3dd06f213b6a700ca9a4d0108";
  };

  buildInputs = [ readline libX11 flex bison libICE libXaw libXext ];

  configureFlags = [ "--enable-x" "--with-x" "--with-readline" "--enable-xspice" "--enable-cider" ];

  meta = with stdenv.lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = http://ngspice.sourceforge.net;
    license = with licenses; [ "BSD" gpl2 ];
    maintainers = with maintainers; [ viric rongcuid ];
    platforms = platforms.linux;
  };
}
