{stdenv, fetchurl, readline, bison, libX11, libICE, libXaw, libXext}:

stdenv.mkDerivation {
  name = "ngspice-25";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-25.tar.gz";
    sha256 = "03hlxwvl2j1wlb5yg4swvmph9gja37c2gqvwvzv6z16vg2wvn06h";
  };

  buildInputs = [ readline libX11 bison libICE libXaw libXext ];

  configureFlags = [ "--enable-x" "--with-x" "--with-readline" ];

  meta = with stdenv.lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = "http://ngspice.sourceforge.net";
    license = with licenses; [ "BSD" gpl2 ];
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
  };
}
