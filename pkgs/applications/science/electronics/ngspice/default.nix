{stdenv, fetchurl, readline, bison, flex, libX11, libICE, libXaw, libXext, fftw}:

stdenv.mkDerivation {
  name = "ngspice-27";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-27.tar.gz";
    sha256 = "15862npsy5sj56z5yd1qiv3y0fgicrzj7wwn8hbcy89fgbawf20c";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ readline libX11 libICE libXaw libXext fftw ];

  configureFlags = [ "--enable-x" "--with-x" "--with-readline" "--enable-xspice" "--enable-cider" ];

  meta = with stdenv.lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = http://ngspice.sourceforge.net;
    license = with licenses; [ "BSD" gpl2 ];
    maintainers = with maintainers; [ bgamari viric rongcuid ];
    platforms = platforms.linux;
  };
}
