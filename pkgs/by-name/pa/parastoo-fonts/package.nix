{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "parastoo-fonts";
  version = "2.0.1";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "parastoo-font";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E94B9R2h227D49dscCBsprmb7w0GrQ+2tWOWRf8FH30=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/rastikerdar/parastoo-font";
    description = "Persian (Farsi) Font - فونت ( قلم ) فارسی پرستو";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pancaek ];
  };
})
