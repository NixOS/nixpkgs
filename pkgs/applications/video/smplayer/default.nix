{ lib, mkDerivation, fetchurl, qmake, qtscript }:

mkDerivation rec {
  pname = "smplayer";
  version = "20.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0kqdx6q2274gm83rycvdcglka60ymdk4iw2lc39iw7z1zgsv6ky3";
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
