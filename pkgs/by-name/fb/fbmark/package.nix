{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbmark";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "caramelli";
    repo = "fbmark";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FioPcU1JWbIC33gN0knPnHWC8JPnQhBzyWYGrwX9TFg=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Linux Framebuffer Benchmark";
    homepage = "https://github.com/caramelli/fbmark";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ davidak ];
    platforms = lib.platforms.linux;
  };
})
