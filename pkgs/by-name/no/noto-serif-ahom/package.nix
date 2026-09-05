{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-serif-ahom";
  version = "2.007";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "ahom";
    tag = "NotoSerifAhom-v${finalAttrs.version}";
    hash = "sha256-H9wHSAJPumoX7GK4bKDzDg/AJHkGX38FJTTRxcUXHE0=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "serif-ahom";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSerifAhom-v"; };

  meta = {
    description = "Modulated (“serif”) design for texts in the Southeast Asian Ahom script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Serif+Ahom";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
