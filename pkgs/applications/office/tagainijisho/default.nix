{
  stdenv,
  lib,
  fetchzip,
  qtbase,
  qttools,
  cmake,
  sqlite,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "tagainijisho";
  version = "1.2.2";

  src = fetchzip {
    url = "https://github.com/Gnurou/tagainijisho/releases/download/${version}/tagainijisho-${version}.tar.gz";
    hash = "sha256-CTDMoYGbVE4W0SDerW//aAdUVsySWFQycSy0I3a9+94=";
  };

  patches = [
    ### Fix cmake minimum version
    ./0000-fix-cmake-min.patch
  ];

  nativeBuildInputs = [
    qttools
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    sqlite
  ];

  cmakeFlags = [
    "-DEMBED_SQLITE=OFF"
  ];

<<<<<<< HEAD
  meta = {
    description = "Free, open-source Japanese dictionary and kanji lookup tool";
    mainProgram = "tagainijisho";
    homepage = "https://www.tagaini.net/";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Free, open-source Japanese dictionary and kanji lookup tool";
    mainProgram = "tagainijisho";
    homepage = "https://www.tagaini.net/";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      # program
      gpl3Plus
      # data
      cc-by-sa-30
    ];
<<<<<<< HEAD
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ vbgl ];
=======
    platforms = platforms.linux;
    maintainers = with maintainers; [ vbgl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
