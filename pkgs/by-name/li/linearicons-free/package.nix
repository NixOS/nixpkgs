{
  lib,
  fetchzip,
  stdenvNoCC,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "linearicons-free";
  version = "1.0.0";

  src = fetchzip {
    url = "https://cdn.linearicons.com/free/${finalAttrs.version}/Linearicons-Free-v${finalAttrs.version}.zip";
    hash = "sha256-0Gb0CRdgzSnpeN+x8TrH5TCrAA57+jsBWZ4FgJ8cm08=";
  };

  nativeBuildInputs = [ installFonts ];

  preInstall = ''cd "$src/Desktop Font/"'';

  meta = {
    description = "Crisp Line Icons by Perxis";
    longDescription = ''
      See cheat sheet here: https://linearicons.com/free#cheat-sheet
    '';
    homepage = "https://linearicons.com/free";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.CardboardTurkey ];
    platforms = lib.platforms.all;
  };
})
