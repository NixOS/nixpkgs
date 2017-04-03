{ stdenv
, fetchurl
, cmake
, makeWrapper
, pkgconfig
, wrapGAppsHook
, gsettings_desktop_schemas

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
  version = "3.6.1";
  src = fetchurl {
    url = "https://github.com/nomacs/nomacs/archive/${version}.tar.gz";
    sha256 = "0s3hm3vv1cqcbg554akbvfzvbm5vbd060jma0b6dqpqsqp58kch9";
  };

  name = "nomacs-${version}";

  enableParallelBuilding = true;

  sourceRoot = "${name}/ImageLounge";

  patches = [./fix-appdata-install.patch];

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
                 gsettings_desktop_schemas];


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
