{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  gpm,
}:

stdenv.mkDerivation rec {
  pname = "jupp";
  version = "41";
  srcName = "joe-3.1${pname}${version}";

  src = fetchurl {
    urls = [
      "https://www.mirbsd.org/MirOS/dist/jupp/${srcName}.tgz"
      "https://mbsd.evolvis.org/MirOS/dist/jupp/${srcName}.tgz"
    ];
    hash = "sha256-e7jqivUZvv7/+T7DyeMhCNfyuDIWybx7Aa71CYhhyC8=";
  };

  preConfigure = "chmod +x ./configure";

  buildInputs = [
    gpm
    ncurses
  ];

  configureFlags = [
    "--enable-curses"
    "--enable-getpwnam"
    "--enable-largefile"
    "--enable-termcap"
    "--enable-termidx"
  ];

  meta = {
    homepage = "http://www.mirbsd.org/jupp.htm";
    downloadPage = "https://www.mirbsd.org/MirOS/dist/jupp/";
    description = "Portable fork of Joe's editor";
    longDescription = ''
      This is the portable version of JOE's Own Editor, which is currently
      developed at sourceforge, licenced under the GNU General Public License,
      Version 1, using autoconf/automake. This version has been enhanced by
      several functions intended for programmers or other professional users,
      and has a lot of bugs fixed. It is based upon an older version of joe
      because these behave better overall.
    '';
    license = lib.licenses.gpl1Only;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; unix;
  };
}
