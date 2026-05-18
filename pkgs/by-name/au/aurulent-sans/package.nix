{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aurulent-sans";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "deepfire";
    repo = "hartke-aurulent-sans";
    tag = "aurulent-sans-${finalAttrs.version}";
    hash = "sha256-M/duhgqxXZJq5su9FrsGjZdm+wtO5B5meoDomde+GwY=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Aurulent Sans";
    longDescription = "Aurulent Sans is a humanist sans serif intended to be used as an interface font";
    homepage = "http://delubrum.org/";
    maintainers = with lib.maintainers; [ deepfire ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
