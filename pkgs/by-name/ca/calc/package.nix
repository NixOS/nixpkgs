{ lib
, stdenv
, fetchurl
, makeWrapper
, ncurses
, readline
, unixtools
, enableReadline ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calc";
  version = "2.15.0.2";

  src = fetchurl {
    urls = [
      "https://github.com/lcn2/calc/releases/download/v${finalAttrs.version}/calc-${finalAttrs.version}.tar.bz2"
      "http://www.isthe.com/chongo/src/calc/calc-${finalAttrs.version}.tar.bz2"
    ];
    hash = "sha256-dPEj32SiR7RhI9fBa9ny9+EEuuiXS2WswRcDVuOMJXc=";
  };

  postPatch = ''
    substituteInPlace Makefile.target \
      --replace '-install_name ''${LIBDIR}/libcalc''${LIB_EXT_VERSION}' '-install_name ''${T}''${LIBDIR}/libcalc''${LIB_EXT_VERSION}' \
      --replace '-install_name ''${LIBDIR}/libcustcalc''${LIB_EXT_VERSION}' '-install_name ''${T}''${LIBDIR}/libcustcalc''${LIB_EXT_VERSION}'
  '';

  nativeBuildInputs = [
    makeWrapper
    unixtools.col
  ];

  buildInputs = lib.optionals enableReadline [
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
    mainProgram = "calc";
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
