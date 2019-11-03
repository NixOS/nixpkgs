{ lib, mkDerivation, fetchurl, qmake, qtscript }:

mkDerivation rec {
  name = "smplayer-19.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0sq7hr10b4pbbi0y1q4mxs24h2lb042nv4rqr03r72bp57353xsl";
  };

  buildInputs = [ qtscript ];
  nativeBuildInputs = [ qmake ];

  dontUseQmakeConfigure = true;

  preConfigure = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    description = "A complete front-end for MPlayer";
    homepage = http://smplayer.sourceforge.net/;
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
