{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jost";
  version = "3.5";

  src = fetchzip {
    url = "https://github.com/indestructible-type/Jost/releases/download/${finalAttrs.version}/Jost.zip";
    hash = "sha256-ne81bMhmTzNZ/GGIzb7nCYh19vNLK+hJ3cP/zDxtiGM=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/indestructible-type/Jost";
    description = "Sans serif font by Indestructible Type";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.ar1a ];
  };
})
