{
  lib,
  stdenv,
  fetchFromGitHub,
  notobuilder,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noto-music";
  version = "2.003-unstable-2025-06-18";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "music";
    # Current release fails building
    rev = "81817dc4bb0c359588e2f370a8182ea028cbc500";
    hash = "sha256-o1ugoCy1uAGErjPAZqEasiQW9wY3UwPZCOjO/l35C7w=";
  };

  env.GITHUB_REF = finalAttrs.src.rev;

  nativeBuildInputs = [
    notobuilder
    installFonts
  ];

  fontName = "music";

  meta = {
    description = "Font that contains symbols for the modern, Byzantine and Greek musical notations";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Music";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jopejoe1 ];
  };
})
