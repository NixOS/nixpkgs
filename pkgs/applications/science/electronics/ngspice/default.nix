{stdenv, fetchurl, readline, bison, libX11, libICE, libXaw, libXext}:

stdenv.mkDerivation {
  name = "ng-spice-rework-24";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-24.tar.gz";
    sha256 = "0rgh75hbqrsljz767whbj65wi6369yc286v0qk8jxnv2da7p9ll6";
  };

  buildInputs = [ readline libX11 bison libICE libXaw libXext ];

  configureFlags = [ "--enable-x" "--with-x" "--with-readline" ];

  meta = {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = "http://ngspice.sourceforge.net";
    license = ["BSD" "GPLv2"];
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
