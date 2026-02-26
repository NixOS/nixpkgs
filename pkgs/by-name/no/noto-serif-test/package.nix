{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-serif-test";
  version = "1.000";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "test";
    tag = "NotoSerifTest-v${finalAttrs.version}";
    hash = "sha256-21rSz/WbLCP5lNV4ZbNfmjNJ+4QlwnTtQ8H4/EugTa4=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "serif-test";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansTest-v"; };

  meta = {
    description = "Testing font for notofonts";
    homepage = "https://github.com/notofonts/test";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
