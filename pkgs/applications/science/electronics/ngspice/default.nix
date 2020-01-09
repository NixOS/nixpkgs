{stdenv, fetchurl, bison, flex
, readline, libX11, libICE, libXaw, libXmu, libXext, libXt, fftw }:

stdenv.mkDerivation rec {
  pname = "ngspice";
  version = "31";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    sha256 = "10n2lnfrpsv4vyrirkphr4jwjjhy7i617g6za78dwirfjq63npw4";
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
