{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fa_1";
  version = "0.100";

  src = fetchzip {
    url = "https://dotcolon.net/files/fonts/fa_1_${lib.replaceString "." "" finalAttrs.version}.zip";
    hash = "sha256-BPJ+wZMYXY/yg5oEgBc5YnswA6A7w6V0gdv+cac0qdc=";
    stripRoot = false;
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://dotcolon.net/font/fa_1/";
    description = "Weighted decorative font";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ minijackson ];
    license = lib.licenses.ofl;
  };
})
