{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "em";
  version = "1.0.0";

  src = fetchurl {
    url = "http://pgas.freeshell.org/C/em/${pname}-${version}.tar.gz";
    hash = "sha256-ijMBkl7U1f9MTXgli9kUFB8ttMG6TMQnxfDMP9AblTQ=";
  };

  meta = with lib; {
    homepage = "http://pgas.freeshell.org/C/em/";
    description = "Editor for Mortals";
    longDescription = ''
      Em is a QMC variant of the standard Unix text editor - ed. It includes all
      of ed, so the documentation for ed is fully applicable to em. Em also has
      a number of new commands and facilities designed to improve its
      interaction and increase its usefulness to users at fast vdu terminals
      (such as the ITT's at QMC).
    '';
    license = licenses.publicDomain;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    mainProgram = "em";
  };
}
