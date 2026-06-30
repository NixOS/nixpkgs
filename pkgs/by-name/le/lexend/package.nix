{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "lexend";
  version = "0.pre+date=2022-09-22";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "lexend";
    rev = "cd26b9c2538d758138c20c3d2f10362ed613854b";
    hash = "sha256-ZKogntyJ/44GBZmFwbtw5Ujw5Gnvv0tVB59ciKqR4c8=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://www.lexend.com";
    description = "Variable font family designed to aid in reading proficiency";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
