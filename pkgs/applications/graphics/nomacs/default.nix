{ stdenv
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, pkgconfig

, qtbase
, qttools
, qtsvg

, exiv2
, opencv4
, libraw
, libtiff
, quazip
}:

mkDerivation rec {
  pname = "nomacs";
  version = "3.15.1616";

  src = fetchFromGitHub {
    owner = "nomacs";
    repo = "nomacs";
    rev = version;
    sha256 = "0g1saqf31zncqdiwk7aaf951j3g33bg0vcjcr5mvg600jxiinw8j";
  };

  enableParallelBuilding = true;

  setSourceRoot = ''
    sourceRoot=$(echo */ImageLounge)
  '';

  nativeBuildInputs = [cmake
                       pkgconfig];

  buildInputs = [qtbase
                 qttools
                 qtsvg
                 exiv2
                 opencv4
                 libraw
                 libtiff
                 quazip];

  cmakeFlags = ["-DENABLE_OPENCV=ON"
                "-DENABLE_RAW=ON"
                "-DENABLE_TIFF=ON"
                "-DENABLE_QUAZIP=ON"
                "-DENABLE_TRANSLATIONS=ON"
                "-DUSE_SYSTEM_QUAZIP=ON"];

  meta = with stdenv.lib; {
    homepage = "https://nomacs.org";
    description = "Qt-based image viewer";
    maintainers = with stdenv.lib.maintainers; [ mindavi ];
    license = licenses.gpl3Plus;
    repositories.git = "https://github.com/nomacs/nomacs.git";
    inherit (qtbase.meta) platforms;
  };
}
