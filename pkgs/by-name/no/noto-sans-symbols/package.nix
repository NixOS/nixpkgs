{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-sans-symbols";
  version = "2.003";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "symbols";
    tag = "NotoSansSymbols-v${finalAttrs.version}";
    hash = "sha256-IXsAvbSweKTPyuy96NC+n6uXQDgwD2Z80ywqYyZJIiQ=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "sans-symbols";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansSymbols-v"; };

  meta = {
    description = "Unmodulated (“sans serif”) design for texts in Symbols";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Symbols";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
