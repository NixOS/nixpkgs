{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-sans-math";
  version = "3.000";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "math";
    tag = "NotoSansMath-v${finalAttrs.version}";
    hash = "sha256-cQV8/yerTYazp2n7kWCGNd89/3eQLNI/h978hd4eZYA=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "sans-math";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansMath-v"; };

  meta = {
    description = "Font that contains symbols for mathematical notation";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Math";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
