{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-sans-devanagari";
  version = "2.006";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "devanagari";
    tag = "NotoSansDevanagari-v${finalAttrs.version}";
    hash = "sha256-hhzTvFkGAZMvUVSN3nPENvTiHDJIxYSPq6HqdNuOfiI=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "sans-devanagari";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansDevanagari-v"; };

  meta = {
    description = "Unmodulated (“sans serif”) design for texts in the Indic Devanagari script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Devanagari";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
