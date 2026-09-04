{
  lib,
  stdenvNoCC,
  fetchurl,

  unrar-free,
  installFonts,
}:
stdenvNoCC.mkDerivation {
  pname = "lazer84";
  version = "1.00";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://web.archive.org/web/20260816055921/https://lazervisuals.com/downloads/lazer84.rar";
    hash = "sha256-K0rcBuIYsY2PODdBoDmCY0cwBOjtzS1XGO69dVOTi6E=";
  };

  nativeBuildInputs = [
    unrar-free
    installFonts
  ];

  meta = {
    description = "Retro 80s style brush font";
    homepage = "https://lazervisuals.com/lazer-84.html";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.ryand56 ];
  };
}
