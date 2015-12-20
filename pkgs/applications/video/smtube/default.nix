{ stdenv, fetchurl, qtscript }:

stdenv.mkDerivation rec {
  version = "15.11.0";
  name = "smtube-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${name}.tar.bz2";
    sha256 = "13pkd0462ygsdlmym6y2cfivihmi175y41jq5hjyh926cgfg7pny";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildInputs = [ qtscript ];

  meta = with stdenv.lib; {
    description = "Play and download Youtube videos";
    homepage = http://smplayer.sourceforge.net/smtube.php;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
  };
}
