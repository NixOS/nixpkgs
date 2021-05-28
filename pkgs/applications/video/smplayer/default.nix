{ lib, mkDerivation, fetchurl, qmake, qtscript }:

mkDerivation rec {
  pname = "smplayer";
  version = "20.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0c59gfgm2ya8yb2nx7gy1zc0nrr4206213xy86y7jw0bk9mmjxmy";
  };

  buildInputs = [ qtscript ];
  nativeBuildInputs = [ qmake ];

  dontUseQmakeConfigure = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "A complete front-end for MPlayer";
    longDescription = "Either mplayer or mpv should also be installed for smplayer to play medias";
    homepage = "https://www.smplayer.info";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
