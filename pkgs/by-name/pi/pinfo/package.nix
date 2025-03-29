{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  fetchpatch,
  gettext,
  ncurses,
  readline,
  stdenv,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "pinfo";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "baszoetekouw";
    repo = "pinfo";
    rev = "v${version}";
    sha256 = "173d2p22irwiabvr4z6qvr6zpr6ysfkhmadjlyhyiwd7z62larvy";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/baszoetekouw/pinfo/commit/16dba5978146b6d3a540ac7c8f415eda49280847.patch";
      sha256 = "148fm32chvq8x9ayq9cnhgszh10g5v0cv0xph67fa7sp341p09wy";
    })

    # Fix pending upstream inclusion for build on ncurses-6.3:
    #   https://github.com/baszoetekouw/pinfo/pull/27
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/baszoetekouw/pinfo/commit/fc67ceacd81f0c74fcab85447c23a532ae482827.patch";
      sha256 = "08phmng8vgfqjjazys05acpd5gh110malhw3sx29dg86nsrg2khs";
    })

    # Fix pending upstream inclusion for build on gcc-11:
    #   https://github.com/baszoetekouw/pinfo/pull/27
    (fetchpatch {
      name = "gcc-11.patch";
      url = "https://github.com/baszoetekouw/pinfo/commit/ab604fdb67296dad27f3a25f3c9aabdd2fb8c3fa.patch";
      sha256 = "09g8msgan2x48hxcbm7l6j3av6n8i0bsd4g0vf5xd8bxwzynb13m";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    gettext
    texinfo
    ncurses
    readline
  ];

  configureFlags = [
    "--with-curses=${ncurses.dev}"
    "--with-readline=${readline.dev}"
  ];

  meta = with lib; {
    description = "Viewer for info files";
    homepage = "https://github.com/baszoetekouw/pinfo";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pinfo";
  };
}
