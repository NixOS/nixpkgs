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
    sha256 = "0n2czl2sy1k6r5ri0hp7jgq84xcwrx4x43bqvw1b4na99mqhyahn";
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
