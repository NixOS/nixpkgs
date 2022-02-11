{ stdenv, lib, fetchurl, util-linux, makeWrapper
, enableReadline ? true, readline, ncurses }:

stdenv.mkDerivation rec {
  pname = "calc";
  version = "2.14.0.14";

  src = fetchurl {
    urls = [
      "https://github.com/lcn2/calc/releases/download/${version}/${pname}-${version}.tar.bz2"
      "http://www.isthe.com/chongo/src/calc/${pname}-${version}.tar.bz2"
    ];
    sha256 = "sha256-93J4NaED2XEsVxlY6STpwlS9FI8I60NIAZvDT45xxV0=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-install_name ''${LIBDIR}/libcalc''${LIB_EXT_VERSION}' '-install_name ''${T}''${LIBDIR}/libcalc''${LIB_EXT_VERSION}' \
      --replace '-install_name ''${LIBDIR}/libcustcalc''${LIB_EXT_VERSION}' '-install_name ''${T}''${LIBDIR}/libcustcalc''${LIB_EXT_VERSION}'
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ util-linux ]
             ++ lib.optionals enableReadline [ readline ncurses ];

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
  ] ++ lib.optionals enableReadline [
    "READLINE_LIB=-lreadline"
    "USE_READLINE=-DUSE_READLINE"
  ];

  meta = with lib; {
    description = "C-style arbitrary precision calculator";
    homepage = "http://www.isthe.com/chongo/tech/comp/calc/";
    # The licensing situation depends on readline (see section 3 of the LGPL)
    # If linked against readline then GPLv2 otherwise LGPLv2.1
    license = with licenses; if enableReadline then gpl2Only else lgpl21Only;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.all;
  };
}
