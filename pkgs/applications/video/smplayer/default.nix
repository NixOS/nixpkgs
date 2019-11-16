{ lib, mkDerivation, fetchurl, qmake, qtscript }:

mkDerivation rec {
  pname = "smplayer";
  version = "19.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0sq7hr10b4pbbi0y1q4mxs24h2lb042nv4rqr03r72bp57353xsl";
  };

  buildInputs = [ qtscript ];
  nativeBuildInputs = [ qmake ];

  dontUseQmakeConfigure = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "A complete front-end for MPlayer";
    longDescription = "Either mplayer or mpv should also be installed for smplayer to play medias";
    homepage = https://www.smplayer.info;
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
