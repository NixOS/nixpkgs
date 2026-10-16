{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-sans-adlam";
  version = "3.002";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "adlam";
    tag = "NotoSansAdlam-v${finalAttrs.version}";
    hash = "sha256-VI5mlCzRHCjzqENwepo3BPCLOzdBPmlBLx8+IyxUNS4=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "sans-adlam";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansAdlam-v"; };

  meta = {
    description = "Joining (cursive) unmodulated (“sans serif”) design for texts in the African Adlam script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Adlam";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
