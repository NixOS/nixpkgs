{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "host-grotesk";
  version = "1.002";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/Element-Type/HostGrotesk/releases/download/${finalAttrs.version}/HostGrotesk-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-xLgIE48TSH5DfjhlUBimEWazSy+vPh1yAxFVUeBwgjI=";
  };

  nativeBuildInputs = [ installFonts ];
  dontInstallWebfonts = true;

  meta = {
    homepage = "https://github.com/Element-Type/HostGrotesk";
    description = "Uniwidth sans-serif typeface based on Poppins";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ozozka ];
  };
})
