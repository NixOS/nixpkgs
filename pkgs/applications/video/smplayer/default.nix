{ lib, mkDerivation, fetchurl, qmake, qtscript }:

mkDerivation rec {
  pname = "smplayer";
  version = "21.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-Y0uq32XoQ8fpIJDScRfA7p3RYd6x1PWZSsYyAYYKf/c=";
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
