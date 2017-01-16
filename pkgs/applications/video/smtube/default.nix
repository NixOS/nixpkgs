{ stdenv, fetchurl, qmakeHook, qtscript, qtwebkit }:

stdenv.mkDerivation rec {
  version = "16.7.2";
  name = "smtube-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${name}.tar.bz2";
    sha256 = "0k64hc6grn4nlp739b0w5fznh0k9xx9qdwx6s7w3fb5m5pfkdrmm";
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
