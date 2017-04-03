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
  version = "3.4";
  src = fetchurl {
    url = "https://github.com/nomacs/nomacs/archive/${version}.tar.gz";
    sha256 = "552eda88aedea48831ce354095e3aad47892b4b5029f424171bedb68271c2a2f";
    sha512 = "67a1b57971dc373d5a3be75b7deaff6702893252568eef135903754b2465416a58b40f18f55cf2994c8c3853ae96b82506c1caf26b0e645c20179a9cd81c0d36";
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
