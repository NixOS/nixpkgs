{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-kufi-arabic";
  version = "2.110";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "arabic";
    tag = "NotoKufiArabic-v${finalAttrs.version}";
    hash = "sha256-HdoUF+HaiTAIMWjUTFrxuGL/taLzfei2rda9eaxPsFI=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "kufi-arabic";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoKufiArabic-v"; };

  meta = {
    description = "Simplified, unmodulated (“sans serif”) Kufi design mainly for texts in larger font sizes in the Middle Eastern Arabic script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Kufi+Arabic";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
