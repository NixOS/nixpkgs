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
  version = "3.14.2";

  src = fetchFromGitHub {
    owner = "nomacs";
    repo = "nomacs";
    rev = version;
    sha256 = "1vms13kyg7cpqi2hxvrrhlnl7cq92ijr7dm1kl5ryglpcagqv811";
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
