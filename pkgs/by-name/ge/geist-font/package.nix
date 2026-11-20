{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "geist-font";
  version = "1.9.2";

  srcs = [
    (fetchzip {
      url = "https://github.com/vercel/geist-font/releases/download/v${finalAttrs.version}/geist-font-v${finalAttrs.version}.zip";
      hash = "sha256-BRx+tfFs9lurWWRBeyxe2voO8hnzJUOrLweqb4o4cM8=";
    })
  ];

  sourceRoot = ".";

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Font family created by Vercel in collaboration with Basement Studio";
    homepage = "https://vercel.com/font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ x0ba ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
