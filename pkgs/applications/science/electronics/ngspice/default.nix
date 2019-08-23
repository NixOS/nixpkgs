{stdenv, fetchurl, bison, flex
, readline, libX11, libICE, libXaw, libXmu, libXext, libXt, fftw }:

stdenv.mkDerivation rec {
  name = "ngspice-${version}";
  version = "30";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    sha256 = "15v0jdfy2a2zxp8dmy04fdp7w7a4vwvffcwa688r81b86wphxzh8";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ readline libX11 libICE libXaw libXmu libXext libXt fftw ];

  configureFlags = [ "--enable-x" "--with-x" "--with-readline" "--enable-xspice" "--enable-cider" ];

  meta = with stdenv.lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = http://ngspice.sourceforge.net;
    license = with licenses; [ "BSD" gpl2 ];
    maintainers = with maintainers; [ bgamari rongcuid ];
    platforms = platforms.linux;
  };
}
