{
  lib,
  stdenv,
  fetchurl,
  fltk_1_3,
  libjpeg,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "4.0.23";
  pname = "flmsg";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/flmsg-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-3eR0wrzkNjlqm5xW5dtgihs33cVUmZeS0/rf+xnPeRY=";
  };

  buildInputs = [
    fltk_1_3
    libjpeg
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Digital modem message program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
    mainProgram = "flmsg";
  };
})
