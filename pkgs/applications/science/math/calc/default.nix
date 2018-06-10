{ stdenv, lib, fetchurl, utillinux, makeWrapper
, enableReadline ? true, readline, ncurses }:

stdenv.mkDerivation rec {
  name = "calc-${version}";
  version = "2.12.6.6";

  src = fetchurl {
    urls = [
      "https://github.com/lcn2/calc/releases/download/${version}/${name}.tar.bz2"
      "http://www.isthe.com/chongo/src/calc/${name}.tar.bz2"
    ];
    sha256 = "03sg1xhin6qsrz82scf96mmzw8lz1yj68rhj4p4npp4s0fawc9d5";
  };

  patchPhase = ''
    substituteInPlace Makefile \
      --replace 'all: check_include' 'all:' \
      --replace '-install_name ''${LIBDIR}/libcalc''${LIB_EXT_VERSION}' '-install_name ''${T}''${LIBDIR}/libcalc''${LIB_EXT_VERSION}' \
      --replace '-install_name ''${LIBDIR}/libcustcalc''${LIB_EXT_VERSION}' '-install_name ''${T}''${LIBDIR}/libcustcalc''${LIB_EXT_VERSION}'
  '';

  buildInputs = [ utillinux makeWrapper ]
             ++ lib.optionals enableReadline [ readline ncurses ];

  makeFlags = [
    "T=$(out)"
    "INCDIR=${lib.getDev stdenv.cc.libc}/include"
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
    homepage = http://www.isthe.com/chongo/tech/comp/calc/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.all;
  };
}
