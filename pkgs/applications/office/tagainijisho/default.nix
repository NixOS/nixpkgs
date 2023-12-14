{ stdenv, lib, fetchzip, qtbase, qttools, cmake, sqlite, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "tagainijisho";
  version = "1.2.2";

  src = fetchzip {
    url = "https://github.com/Gnurou/tagainijisho/releases/download/${version}/tagainijisho-${version}.tar.gz";
    hash = "sha256-CTDMoYGbVE4W0SDerW//aAdUVsySWFQycSy0I3a9+94=";
  };

  nativeBuildInputs = [ qttools cmake wrapQtAppsHook ];
  buildInputs = [ qtbase sqlite ];

  cmakeFlags = [
    "-DEMBED_SQLITE=OFF"
  ];

  meta = with lib; {
    description = "A free, open-source Japanese dictionary and kanji lookup tool";
    homepage = "https://www.tagaini.net/";
    license = with licenses; [
      /* program */
      gpl3Plus
      /* data */
      cc-by-sa-30
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ vbgl ];
  };
}
