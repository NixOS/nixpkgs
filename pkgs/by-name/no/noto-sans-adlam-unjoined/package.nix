{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-sans-adlam-unjoined";
  version = "3.003";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "adlam";
    tag = "NotoSansAdlamUnjoined-v${finalAttrs.version}";
    hash = "sha256-WcJOhMl+KIXHugvbNILJUhlQW/f3pbqGVO+XCo24ZEw=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "sans-adlam-unjoined";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansAdlamUnjoined-v"; };

  meta = {
    description = "Unjoined unmodulated (“sans serif”) design suitable for headlines and for educational content in the African Adlam script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Adlam+Unjoined";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
