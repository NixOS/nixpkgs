{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "marathi-cursive";
  version = "2.1";

  src = fetchurl {
    url = "https://github.com/MihailJP/MarathiCursive/releases/download/v${finalAttrs.version}/MarathiCursive-${finalAttrs.version}.tar.xz";
    hash = "sha256-C/z8ALV9bht0SaYqACO5ulSVCk1d6wBwvpVC4ZLgtek=";
  };

  postInstall = ''
    install -m444 -Dt $out/share/doc/${finalAttrs.pname}-${finalAttrs.version} README *.txt
  '';

  meta = {
    homepage = "https://github.com/MihailJP/MarathiCursive";
    description = "Modi script font with Graphite and OpenType support";
    maintainers = with lib.maintainers; [ mathnerd314 ];
    license = lib.licenses.mplus;
    platforms = lib.platforms.all;
  };
})
