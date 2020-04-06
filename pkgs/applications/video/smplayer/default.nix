{ lib, mkDerivation, fetchurl, qmake, qtscript }:

mkDerivation rec {
  pname = "smplayer";
  version = "19.10.2";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0i2c15yxk4by2zyjhb7n08larz9pmpa6zw383aybjxqh0nd9zv9p";
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
