{
  lib,
  stdenv,
  fetchFromCodeberg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dev86";
  version = "1.0.1-unstable-2026-05-15";

  src = fetchFromCodeberg {
    owner = "jbruchon";
    repo = "dev86";
    rev = "8cf785fc11516b31404ea6593d9fc5a411f59dad";
    hash = "sha256-nY5awJzEO+xbJRAbeRJgKjJf30SNz2Bg346KMNDtmls=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://codeberg.org/jbruchon/dev86";
    description = "C compiler, assembler and linker environment for the production of 8086 executables";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      sigmasquadron
    ];
    platforms = lib.platforms.linux;
  };
})
