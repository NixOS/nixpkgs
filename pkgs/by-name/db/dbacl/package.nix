{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "dbacl";
  version = "1.14";

  src = fetchurl {
    url = "https://www.lbreyer.com/gpl/dbacl-${version}.tar.gz";
    sha256 = "0224g6x71hyvy7jikfxmgcwww1r5lvk0jx36cva319cb9nmrbrq7";
  };

  meta = with lib; {
    homepage = "https://dbacl.sourceforge.net/";
    longDescription = "a digramic Bayesian classifier for text recognition.";
    maintainers = [ ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
