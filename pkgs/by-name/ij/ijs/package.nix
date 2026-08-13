{
  lib,
  stdenv,
  autoreconfHook,
  ghostscript,
}:

stdenv.mkDerivation {
  pname = "ijs";
  inherit (ghostscript) version src;

  postPatch = "cd ijs";

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--enable-shared" ];

  meta = {
    homepage = "https://www.openprinting.org/download/ijs/";
    description = "Raster printer driver architecture";

    license = lib.licenses.gpl3Plus;

    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
