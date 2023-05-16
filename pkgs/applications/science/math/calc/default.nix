{ lib
, stdenv
, fetchurl
, makeWrapper
, ncurses
, readline
<<<<<<< HEAD
, unixtools
=======
, util-linux
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, enableReadline ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calc";
<<<<<<< HEAD
  version = "2.14.3.5";
=======
  version = "2.14.1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    urls = [
      "https://github.com/lcn2/calc/releases/download/v${finalAttrs.version}/calc-${finalAttrs.version}.tar.bz2"
      "http://www.isthe.com/chongo/src/calc/calc-${finalAttrs.version}.tar.bz2"
    ];
<<<<<<< HEAD
    hash = "sha256-4eXs6NDfsJO5Vr9Mo2jC16hTRAyt++1s+Z/JrWDKwUk=";
=======
    hash = "sha256-bPacYnEJBdQsIP+Z8D/ODskyEcvhgAy3ra4wasYMo6A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-install_name ''${LIBDIR}/libcalc''${LIB_EXT_VERSION}' '-install_name ''${T}''${LIBDIR}/libcalc''${LIB_EXT_VERSION}' \
      --replace '-install_name ''${LIBDIR}/libcustcalc''${LIB_EXT_VERSION}' '-install_name ''${T}''${LIBDIR}/libcustcalc''${LIB_EXT_VERSION}'
  '';

  nativeBuildInputs = [
    makeWrapper
<<<<<<< HEAD
    unixtools.col
  ];

  buildInputs = lib.optionals enableReadline [
=======
  ];

  buildInputs = [
    util-linux
  ]
  ++ lib.optionals enableReadline [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ncurses
    readline
  ];

  makeFlags = [
    "T=$(out)"
    "INCDIR="
    "BINDIR=/bin"
    "LIBDIR=/lib"
    "CALC_SHAREDIR=/share/calc"
    "CALC_INCDIR=/include"
    "MANDIR=/share/man/man1"

    # Handle LDFLAGS defaults in calc
    "DEFAULT_LIB_INSTALL_PATH=$(out)/lib"
  ]
  ++ lib.optionals enableReadline [
    "READLINE_LIB=-lreadline"
    "USE_READLINE=-DUSE_READLINE"
  ];

  meta = {
    homepage = "http://www.isthe.com/chongo/tech/comp/calc/";
    description = "C-style arbitrary precision calculator";
    changelog = "https://github.com/lcn2/calc/blob/v${finalAttrs.version}/CHANGES";
    # The licensing situation depends on readline (see section 3 of the LGPL)
    # If linked against readline then GPLv2 otherwise LGPLv2.1
    license = if enableReadline
              then lib.licenses.gpl2Only
              else lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ matthewbauer ];
    platforms = lib.platforms.all;
  };
})
