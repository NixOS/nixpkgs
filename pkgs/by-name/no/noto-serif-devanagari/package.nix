{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-serif-devanagari";
  version = "2.006";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "devanagari";
    tag = "NotoSerifDevanagari-v${finalAttrs.version}";
    hash = "sha256-V+ikOT0EbtLPsnauNIIOimUUoxFKCCxIJRPIgZusPZE=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "serif-devanagari";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSerifDevanagari-v"; };

  meta = {
    description = "Modulated (“serif”) design for texts in the Indic Devanagari script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Serif+Devanagari";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
