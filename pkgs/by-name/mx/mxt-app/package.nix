{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.52";
  pname = "mxt-app";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-CW2iWkYuI0joTQJXt271XLO70Qq/Yg8eX9f56XnJht8=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];

  hardeningDisable = [ "fortify" ];

  meta = {
    description = "Command line utility for Atmel maXTouch devices";
    homepage = "https://github.com/atmel-maxtouch/mxt-app";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "mxt-app";
  };
})
