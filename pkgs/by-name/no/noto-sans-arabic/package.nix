{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-sans-arabic";
  version = "2.013";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "arabic";
    tag = "NotoSansArabic-v${finalAttrs.version}";
    hash = "sha256-HdoUF+HaiTAIMWjUTFrxuGL/taLzfei2rda9eaxPsFI=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "sans-arabic";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansArabic-v"; };

  meta = {
    description = "Unmodulated (“sans serif”) design for texts in the Middle Eastern Arabic script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Arabic";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
