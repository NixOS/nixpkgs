{ stdenv
, fetchFromGitHub
, cmake
, makeWrapper
, pkgconfig
, wrapGAppsHook
, gsettings-desktop-schemas

, qtbase
, qttools
, qtsvg

, exiv2
, opencv
, libraw
, libtiff
, quazip
}:

stdenv.mkDerivation rec {
  version = "3.10.0";
  src = fetchFromGitHub {
    owner = "nomacs";
    repo = "nomacs";
    rev = version;
    sha256 = "07k921r4m6p5kicyb55zdfp58m8mlc94g2csq354d7v20m71zwrv";
  };

  name = "nomacs-${version}";

  enableParallelBuilding = true;

  setSourceRoot = ''
    sourceRoot=$(echo */ImageLounge)
  '';

  nativeBuildInputs = [cmake
                       pkgconfig
                       wrapGAppsHook];

  buildInputs = [qtbase
                 qttools
                 qtsvg
                 exiv2
                 opencv
                 libraw
                 libtiff
                 quazip
                 gsettings-desktop-schemas];

  cmakeFlags = ["-DENABLE_OPENCV=ON"
                "-DENABLE_RAW=ON"
                "-DENABLE_TIFF=ON"
                "-DENABLE_QUAZIP=ON"
                "-DUSE_SYSTEM_QUAZIP=ON"];

  meta = with stdenv.lib; {
    homepage = https://nomacs.org;
    description = "Qt-based image viewer";
    maintainers = [maintainers.ahmedtd];
    license = licenses.gpl3Plus;
    repositories.git = https://github.com/nomacs/nomacs.git;
    inherit (qtbase.meta) platforms;
  };
}
