{
  lib,
  stdenv,
  fetchgit,
  alsa-lib,
  libsndfile,
  libvorbis,
  mpg123,
  sndio,
  soxr,
}:

stdenv.mkDerivation {
  pname = "sad-2f30";
  version = "0-unstable-2021-01-21";

  src = fetchgit {
    url = "https://git.2f30.org/sad";
    rev = "103dca11868636dba3b8ae04ab4dbbc7bd5b8b9f";
    hash = "sha256-P4Ok9ufhB5/O9j4yV+9LM35zOlFxKpHkpIjSTic4a/E=";
  };

  buildInputs = [
    alsa-lib
    libsndfile
    libvorbis
    mpg123
    sndio
    soxr
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Simple audio daemon controlled over a UNIX socket";
    homepage = "https://git.2f30.org/sad/";
    license = lib.licenses.isc;
    mainProgram = "sad";
    maintainers = with lib.maintainers; [ equwal ];
    platforms = lib.platforms.linux;
  };
}
