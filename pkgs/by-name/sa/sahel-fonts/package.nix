{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sahel-fonts";
  version = "3.4.0";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "sahel-font";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U4tIICXZFK9pk7zdzRwBPIPYFUlYXPSebnItUJUgGJY=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/rastikerdar/sahel-font";
    description = "Persian (farsi) Font - فونت (قلم) فارسی ساحل";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pancaek ];
  };
})
