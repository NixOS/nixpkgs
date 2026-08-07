{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-naskh-arabic";
  version = "2.021";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "arabic";
    tag = "NotoNaskhArabic-v${finalAttrs.version}";
    hash = "sha256-D4vbL51ZzSFZRH+qOKUUFfw7kq1NXlui5Xx/dVaNG8Y=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "naskh-arabic";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoNaskhArabic-v"; };

  meta = {
    description = "Modulated (“serif”) Naskh design, suitable for texts in the Middle Eastern Arabic script and for use together with serif fonts";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Naskh+Arabic";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
