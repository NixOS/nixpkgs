{stdenv, fetchurl, bison, flex
, readline, libX11, libICE, libXaw, libXmu, libXext, libXt, fftw }:

stdenv.mkDerivation {
  name = "ngspice-28";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-28.tar.gz";
    sha256 = "0rnz2rdgyav16w7wfn3sfrk2lwvvgz1fh0l9107zkcldijklz04l";
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
