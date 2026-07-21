{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "fira-code-symbols";
  version = "20160811";

  src = fetchzip {
    url = "https://github.com/tonsky/FiraCode/files/412440/FiraCode-Regular-Symbol.zip";
    hash = "sha256-7y51blEn0Osf8azytK08zJgtfVX/CIWQkiOoRzYKIa4=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "FiraCode unicode ligature glyphs in private use area";
    longDescription = ''
      FiraCode uses ligatures, which some editors don’t support.
      This addition adds them as glyphs to the private unicode use area.
      See https://github.com/tonsky/FiraCode/issues/211.
    '';
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    homepage = "https://github.com/tonsky/FiraCode/issues/211#issuecomment-239058632";
  };
}
