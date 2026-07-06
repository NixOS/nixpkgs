{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "roboto-flex";
  version = "3.200";

  src = fetchzip {
    url = "https://github.com/googlefonts/roboto-flex/releases/download/${finalAttrs.version}/roboto-flex-fonts.zip";
    hash = "sha256-p8BvE4f6zQLygl49hzYTXXVQFZEJjrlfUvjNW+miar4=";
  };

  sourceRoot = "${finalAttrs.src.name}/roboto-flex-fonts/fonts";

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/googlefonts/roboto-flex";
    description = "Google Roboto Flex family of fonts";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
})
