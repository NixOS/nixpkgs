{
  fetchgit,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gendef";
  version = "14.0.0";

  src = fetchgit {
    url = "https://git.code.sf.net/p/mingw-w64/mingw-w64.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZhbY/RvTBI8ELSe0D7uzWi13sspgNZhdYg4LLK0JRng=";
  };

  sourceRoot = "${finalAttrs.src.name}/mingw-w64-tools/gendef";

  meta = {
    description = "Tool which generate def files from DLLs";
    mainProgram = "gendef";
    homepage = "https://sourceforge.net/p/mingw-w64/wiki2/gendef/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = lib.platforms.linux;
  };
})
