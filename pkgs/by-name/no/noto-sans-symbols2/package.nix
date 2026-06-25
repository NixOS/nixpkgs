{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-sans-symbols2";
  version = "2.008";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "symbols";
    tag = "NotoSansSymbols2-v${finalAttrs.version}";
    hash = "sha256-ujZ3IJrWmkxKcmVl1FZuMF5ovbMkd2wcGU6DuJTo7Eg=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "sans-symbols2";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansSymbols2-v"; };

  meta = {
    description = "Unmodulated (“sans serif”) design for texts in Symbols and in Emoji symbols";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Symbols+2";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
