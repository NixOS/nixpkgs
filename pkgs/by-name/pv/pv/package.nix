{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pv";
  version = "1.9.27";

  src = fetchurl {
    url = "https://www.ivarch.com/programs/sources/pv-${finalAttrs.version}.tar.gz";
    hash = "sha256-JTZZ3IZWk2PwZfXogeE1oMlZS5h/NKGbEEx0FKLSxHk=";
  };

  meta = with lib; {
    homepage = "https://www.ivarch.com/programs/pv.shtml";
    description = "Tool for monitoring the progress of data through a pipeline";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.all;
    mainProgram = "pv";
  };
})
