{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-serif";
  version = "2.013";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "latin-greek-cyrillic";
    tag = "NotoSerif-v${finalAttrs.version}";
    hash = "sha256-guiiPnvlJPA7g5MRFoffj91q3ETljh1bIJDV/vP7qww=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "serif";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSerif-v"; };

  meta = {
    description = "Modulated (“serif”) design for texts in the Latin, Cyrillic and Greek scripts";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Serif";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
