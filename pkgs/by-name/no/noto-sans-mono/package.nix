{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-sans-mono";
  version = "2.014";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "latin-greek-cyrillic";
    tag = "NotoSansMono-v${finalAttrs.version}";
    hash = "sha256-guiiPnvlJPA7g5MRFoffj91q3ETljh1bIJDV/vP7qww=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "sans-mono";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansMono-v"; };

  meta = {
    description = "Monospaced, unmodulated (“sans serif”) design suitable for programming code and other uses where a fixed-width font is needed";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Mono";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
