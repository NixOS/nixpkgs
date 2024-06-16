{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  flac,
  libao,
  libogg,
  popt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flac123";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "flac123";
    repo = "flac123";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LtL69t2r9TlIkpQWZLge8ib7NZ5rvLW6JllG2UM16Kw=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    flac
    libao
    libogg
    popt
  ];

  meta = {
    homepage = "https://github.com/flac123/flac123";
    description = "A command-line program for playing FLAC audio files";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kiike ];
    mainProgram = "flac123";
    platforms = lib.platforms.unix;
  };
})
