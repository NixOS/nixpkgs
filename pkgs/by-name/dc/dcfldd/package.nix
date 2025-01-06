{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "dcfldd";
  version = "1.3.4-1";

  src = fetchurl {
    url = "mirror://sourceforge/dcfldd/dcfldd-${version}.tar.gz";
    sha256 = "1y6mwsvm75f5jzxsjjk0yhf8xnpmz6y8qvcxfandavx59lc3l57m";
  };

  meta = {
    description = "Enhanced version of GNU dd";

    homepage = "https://dcfldd.sourceforge.net/";

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ qknight ];
    mainProgram = "dcfldd";
  };
}
