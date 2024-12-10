{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "bviplus";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/bviplus/bviplus/${version}/bviplus-${version}.tgz";
    sha256 = "08q2fdyiirabbsp5qpn3v8jxp4gd85l776w6gqvrbjwqa29a8arg";
  };

  patches = [
    # Fix pending upstream inclusion for ncurses-6.3 support:
    #  https://sourceforge.net/p/bviplus/bugs/7/
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://sourceforge.net/p/bviplus/bugs/7/attachment/bviplus-ncurses-6.2.patch";
      sha256 = "1g3s2fdly3qliy67f3dlb12a03a21zkjbya6gap4mqxhyyjbp46x";
      # svn patch, rely on prefix added by fetchpatch:
      extraPrefix = "";
    })
  ];

  buildInputs = [
    ncurses
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "CFLAGS=-fgnu89-inline" ];

  meta = with lib; {
    description = "Ncurses based hex editor with a vim-like interface";
    homepage = "https://bviplus.sourceforge.net";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    mainProgram = "bviplus";
  };
}
