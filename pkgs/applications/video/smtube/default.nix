{ stdenv, fetchurl, qmakeHook, qtscript, qtwebkit }:

stdenv.mkDerivation rec {
  version = "16.1.0";
  name = "smtube-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${name}.tar.bz2";
    sha256 = "1yjn7gj5pfw8835gfazk29mhcvfh1dhfjqmbqln1ajxr89imjj4r";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  dontUseQmakeConfigure = true;

  buildInputs = [ qmakeHook qtscript qtwebkit ];

  meta = with stdenv.lib; {
    description = "Play and download Youtube videos";
    homepage = http://smplayer.sourceforge.net/smtube.php;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
  };
}
