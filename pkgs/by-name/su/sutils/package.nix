{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.2";
  pname = "sutils";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "sutils";
    rev = finalAttrs.version;
    hash = "sha256-0qh9Ev41Ef9mscrPPY3FvHryta0HwzaC4QOr1o0yT0Q=";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ alsa-lib ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = {
    description = "Small command-line utilities";
    homepage = "https://github.com/baskerville/sutils";
    maintainers = [ lib.maintainers.meisternu ];
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
  };
})
