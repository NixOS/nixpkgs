{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config

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
  version = "3.17.2206";

  src = fetchFromGitHub {
    owner = "nomacs";
    repo = "nomacs";
    rev = version;
    sha256 = "1bq7bv4p7w67172y893lvpk90d6fgdpnylynbj2kn8m2hs6khya4";
  };

  patches = [
    # Add support for Quazip 1.x.
    (fetchpatch {
      url = "https://github.com/nomacs/nomacs/pull/576.patch";
      sha256 = "11ryjvd9jbb0cqagai4a6980jfq8lrcbyw2d7z9yld1f42w9kbxm";
      stripLen = 1;
    })
  ];

  setSourceRoot = ''
    sourceRoot=$(echo */ImageLounge)
  '';

  nativeBuildInputs = [cmake
                       pkg-config];

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

  meta = with lib; {
    homepage = "https://nomacs.org";
    description = "Qt-based image viewer";
    maintainers = with lib.maintainers; [ mindavi ];
    license = licenses.gpl3Plus;
    repositories.git = "https://github.com/nomacs/nomacs.git";
    inherit (qtbase.meta) platforms;
  };
}
