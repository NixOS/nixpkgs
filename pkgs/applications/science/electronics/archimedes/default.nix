{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "archimedes-2.0.1";

  src = fetchurl {
    url = "mirror://gnu/archimedes/${name}.tar.gz";
    sha256 = "0jfpnd3pns5wxcxbiw49v5sgpmm5b4v8s4q1a5292hxxk2hzmb3z";
  };

  meta = {
    description = "GNU package for semiconductor device simulations";
    homepage = http://www.gnu.org/software/archimedes;
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
