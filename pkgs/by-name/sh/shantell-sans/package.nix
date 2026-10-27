{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shantell-sans";
  version = "1.011";

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://github.com/arrowtype/shantell-sans/releases/download/${finalAttrs.version}/Shantell_Sans_${finalAttrs.version}.zip";
    hash = "sha256-xgE4BSl2A7yeVP5hWWUViBDoU8pZ8KkJJrsSfGRIjOk=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "A marker-style variable font by ArrowType and Shantell Martin";
    homepage = "https://github.com/arrowtype/shantell-sans";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      benhaskins
    ];
  };
})
