{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  libao,
  libmodplug,
  libsamplerate,
  libsndfile,
  libvorbis,
  ncurses,
  which,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "frotz";
  version = "2.55";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "DavidGriffith";
    repo = "frotz";
    rev = version;
    hash = "sha256-Gsi6i1cXTONA9iZ39dPy1QH5trIg7P++/D/VVzexmpg=";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/5c70d849addb2df2ea9ad2cc4fd4a15e5d4cc3a5/games/frotz/files/Makefile.patch";
      extraPrefix = "";
      hash = "sha256-ydIA1Td1ufp4y4Qfm5ijg9AY8z7cQ8BiX9hQz8gkKZY=";
    })
  ];

  nativeBuildInputs = [
    which
    pkg-config
  ];
  buildInputs = [
    libao
    libmodplug
    libsamplerate
    libsndfile
    libvorbis
    ncurses
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://davidgriffith.gitlab.io/frotz/";
    changelog = "https://gitlab.com/DavidGriffith/frotz/-/raw/${version}/NEWS";
    description = "Z-machine interpreter for Infocom games and other interactive fiction";
    mainProgram = "frotz";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      nicknovitski
      ddelabru
    ];
    license = lib.licenses.gpl2Plus;
  };
}
