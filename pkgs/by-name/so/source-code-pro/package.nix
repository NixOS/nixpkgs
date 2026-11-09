{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "source-code-pro";
  version = "2.042";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-code-pro/releases/download/${finalAttrs.version}R-u%2F1.062R-i%2F1.026R-vf/OTF-source-code-pro-${finalAttrs.version}R-u_1.062R-i.zip";
    stripRoot = false;
    hash = "sha256-+BnfmD+AjObSoVxPvFAqbnMD2j5qf2YmbXGQtXoaiy0=";
  };

  nativeBuildInputs = [
    installFonts
  ];

  meta = {
    description = "Monospaced font family for user interface and coding environments";
    maintainers = with lib.maintainers; [ coolcuber ];
    platforms = lib.platforms.all;
    homepage = "https://adobe-fonts.github.io/source-code-pro/";
    license = lib.licenses.ofl;
  };
})
