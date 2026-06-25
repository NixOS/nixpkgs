{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-znamenny-musical-notation";
  version = "1.003";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "znamenny";
    tag = "NotoZnamennyMusicalNotation-v${finalAttrs.version}";
    hash = "sha256-hoe4KocblsEIP59lR+sntZMddMkor8gQAe2ZmKYpvPM=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "znamenny";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoZnamennyMusicalNotation-v"; };

  meta = {

    description = "Font that contains symbols for the Znamenny Chant musical notation";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Znamenny+Musical+Notation";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
