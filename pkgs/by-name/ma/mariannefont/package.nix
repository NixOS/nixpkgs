{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mariannefont";
  version = "0-unstable-2021-12-05";

  src = fetchFromGitHub {
    owner = "JohannCOSTE";
    repo = "marianne_ttf_tcpdf";
    rev = "ee4d5025cd37b03562a0f2fb333b081fe7196dc5";
    hash = "sha256-outIIWJtUWZW527i9ciP0AT5LGaQDO6IK9Kn6R8w6ZU=";
  };

  nativeBuildInputs = [ installFonts ];
  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    homepage = "https://www.info.gouv.fr/marque-de-letat/la-typographie";
    description = "Font to be used in official French State
    communication";
    # Seems the official website forbid the use of the font for non-State
    # communication, but the official decree
    # https://www.legifrance.gouv.fr/circulaire/id/44935 is not that clear
    # on that matter
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ GirardR1006 ];
    platforms = lib.platforms.all;
  };
})
