{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  version = "15.8.0";
  name = "smtube-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${name}.tar.bz2";
    sha256 = "0hxh3axlhd16ffnkynm4lcfpkwkfv19y70cqgpqrdj2gl8f917bp";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildInputs = [ qt4 ];

  meta = with stdenv.lib; {
    description = "Play and download Youtube videos";
    homepage = http://smplayer.sourceforge.net/smtube.php;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
  };
}
