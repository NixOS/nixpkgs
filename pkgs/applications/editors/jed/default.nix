{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  gpm,
  libXext,
  libXft,
  libXt,
  ncurses5,
  slang,
}:

stdenv.mkDerivation rec {
  pname = "jed";
  version = "0.99-19";

  src = fetchzip {
    url = "https://www.jedsoft.org/releases/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-vzeX0P+2+IuKtrX+2lQDeJj7VMDS6XurD2pb2jhxy2Q=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gpm
    libXext
    libXft
    libXt
    ncurses5
    slang
  ];

  configureFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "--with-slang=${slang}"
    "JED_ROOT=${placeholder "out"}/share/jed"
  ];

  makeFlags = [
    "jed"
    "xjed"
    "rgrep"
  ];

  postPatch = ''
    for i in autoconf/Makefile autoconf/Makefile.in \
             doc/tm/Makefile src/Makefile.in; do
      sed -e 's|/bin/cp|cp|' -i $i
    done
    for i in autoconf/aclocal.m4 configure; do
      sed -e 's|ncurses5|ncurses|' -i $i
    done
  '';

  postInstall = ''
    install -D src/objs/rgrep $out/bin
  '';

  meta = with lib; {
    description = "A programmable text editor written around S-Lang";
    longDescription = ''
      JED is a freely available text editor for Unix, VMS, MSDOS, OS/2, BeOS,
      QNX, and win9X/NT platforms. Although it is a powerful editor designed for
      use by programmers, its drop-down menu facility make it one of the
      friendliest text editors around. Hence it is ideal for composing simple
      email messages as well as editing complex programs in a variety of
      computer languages.

      JED makes extensive use of the S-Lang library, which endows it with the
      powerful S-Lang scripting language. Some of its features are:

      - Color syntax highlighting on color terminals, e.g., Linux console or a
        remote color terminal via dialup (as well as Xjed)
      - Folding support
      - Drop-down menus on _ALL_ terminals/platforms
      - Emulation of Emacs, EDT, Wordstar, Borland, and Brief editors
      - Extensible in the C-like S-Lang language making the editor completely
        customizable.
      - Capable of reading GNU info files from within JED's info browser
      - A variety of programming modes (with syntax highlighting) are available
        including C, C++, FORTRAN, TeX, HTML, SH, python, IDL, DCL, NROFF...
      - Edit TeX files with AUC-TeX style editing (BiBTeX support too)
      - Asynchronous subprocess support allowing one to compile from within the
        editor
      - Built-in support for the GPM mouse driver on Linux console
      - Abbreviation mode and Dynamic abbreviation mode
      - 8 bit clean with mute/dead key support
      - Supported on most Unix, VMS, OS/2, MSDOS (386+), win9X/NT, QNX, and BeOS
        systems
      - Rectangular cut/paste; regular expressions; incremental searches; search
        replace across multiple files; multiple windows; multiple buffers; shell
        modes; directory editor (dired); mail; rmail; ispell; and much, much
        more
    '';
    homepage = "https://www.jedsoft.org/jed/index.html";
    license = licenses.gpl2Plus;
    platforms = slang.meta.platforms;
  };
}
# TODO: build tex documentation
