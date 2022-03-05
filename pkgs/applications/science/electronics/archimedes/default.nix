{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "archimedes";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://gnu/archimedes/archimedes-${version}.tar.gz";
    sha256 = "0jfpnd3pns5wxcxbiw49v5sgpmm5b4v8s4q1a5292hxxk2hzmb3z";
  };

  meta = {
    description = "GNU package for semiconductor device simulations";
    homepage = "https://www.gnu.org/software/archimedes";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
  };
}
