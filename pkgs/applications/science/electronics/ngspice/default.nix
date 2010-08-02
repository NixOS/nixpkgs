{stdenv, fetchurl, readline, bison, libX11, libICE, libXaw, libXext}:

stdenv.mkDerivation {
  name = "ng-spice-rework-21";

  src = fetchurl {
    url = mirror://sourceforge/ngspice/ng-spice-rework-21.tar.gz;
    sha256 = "1hmvfl33dszy8xgbixx0zmiz4rdzjhl7lwlwm953jibd4dgx42j5";
  };

  buildInputs = [ readline libX11 bison libICE libXaw libXext ];

  configureFlags = [ "--enable-x" "--with-x" "--with-readline" ];

  meta = {
    description = "The Next Generation Spice (Electronic Circuit Simulator).";
    homepage = http://ngspice.sourceforge.net;
    license = ["BSD" "GPLv2"];
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
