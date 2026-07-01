{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "samim-fonts";
  version = "4.0.5";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "samim-font";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DVBMsNOVAVwzlZ3cDus/3CSsC05bLZalQ2KeueEvwXs=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/rastikerdar/samim-font";
    description = "Persian (Farsi) Font - فونت (قلم) فارسی صمیم";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pancaek ];
  };
})
