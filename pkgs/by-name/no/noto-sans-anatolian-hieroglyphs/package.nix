{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-sans-anatolian-hieroglyphs";
  version = "2.001";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "anatolian-hieroglyphs";
    tag = "NotoSansAnatolianHieroglyphs-v${finalAttrs.version}";
    hash = "sha256-OkAVkGpFZolQQs/zArSIxytnvZl7Kh/cwVnrpfB/J/Q=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "sans-anatolian-hieroglyphs";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansAnatolianHieroglyphs-v"; };

  meta = {
    description = "Unmodulated (“sans serif”) design for texts in the historical Middle Eastern Anatolian hieroglyphs script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Anatolian+Hieroglyphs";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
