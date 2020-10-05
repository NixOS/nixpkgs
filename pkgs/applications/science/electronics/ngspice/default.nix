{ stdenv
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
  version = "32";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    sha256 = "1wiys30c9mqzxr7iv1sws0jnn4xi0mj3lanhnk2qfvaiji70rn9w";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ readline libX11 libICE libXaw libXmu libXext libXt fftw ];

  configureFlags = [ "--enable-x" "--with-x" "--with-readline" "--enable-xspice" "--enable-cider" ];

  meta = with stdenv.lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = "http://ngspice.sourceforge.net";
    license = with licenses; [ "BSD" gpl2 ];
    maintainers = with maintainers; [ bgamari rongcuid ];
    platforms = platforms.linux;
  };
}
