{
  lib,
  stdenv,
  fetchurl,
  python ? null,
  withPython ? false,
}:

stdenv.mkDerivation rec {
  pname = "fastjet";
  version = "3.4.2";

  src = fetchurl {
    url = "http://fastjet.fr/repo/fastjet-${version}.tar.gz";
    hash = "sha256-s9MxVbVc5D9CDNbZm1Jaz3vcJZOnu36omKnds9jKOOM=";
  };

  buildInputs = lib.optional withPython python;

  configureFlags = [
    "--enable-allcxxplugins"
  ] ++ lib.optional withPython "--enable-pyext";

  enableParallelBuilding = true;

  meta = {
    description = "Software package for jet finding in pp and e+e− collisions";
    mainProgram = "fastjet-config";
    license = lib.licenses.gpl2Plus;
    homepage = "http://fastjet.fr/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
