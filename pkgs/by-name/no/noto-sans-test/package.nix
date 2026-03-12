{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-sans-test";
  version = "1.002";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "test";
    tag = "NotoSansTest-v${finalAttrs.version}";
    hash = "sha256-PoDF3XVqA5cy1Mcqbj+Grj58G/VTqEYMRuIYnbRumiY=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "sans-test";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansTest-v"; };

  meta = {
    description = "Testing font for notofonts";
    homepage = "https://github.com/notofonts/test";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
