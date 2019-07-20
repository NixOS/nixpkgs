{ stdenv, fetchurl
, ncurses, gpm
}:

stdenv.mkDerivation rec {

  name = "jupp-${version}";
  version = "3.1";
  srcName = "joe-3.1jupp31";

  src = fetchurl {
    urls = [
      "https://www.mirbsd.org/MirOS/dist/jupp/${srcName}.tgz"
      "https://pub.allbsd.org/MirOS/dist/jupp/${srcName}.tgz" ];
    sha256 = "1fnf9jsd6p4jyybkhjjs328qx38ywy8w029ngc7j7kqp0ixn0l0s";
  };

  preConfigure = "chmod +x ./configure";

  buildInputs = [ ncurses gpm ];

  configureFlags = [
    "--enable-curses"
    "--enable-termcap"
    "--enable-termidx"
    "--enable-getpwnam"
    "--enable-largefile"
  ];

  meta = with stdenv.lib; {
    description = "A portable fork of Joe's editor";
    longDescription = ''
      This is the portable version of JOE's Own Editor, which is currently
      developed at sourceforge, licenced under the GNU General Public License,
      Version 1, using autoconf/automake. This version has been enhanced by
      several functions intended for programmers or other professional users,
      and has a lot of bugs fixed. It is based upon an older version of joe
      because these behave better overall.
    '';
    homepage = http://mirbsd.de/jupp;
    license = licenses.gpl1;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
