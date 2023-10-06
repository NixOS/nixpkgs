{ stdenv
, lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config

, qtbase
, qttools
, qtsvg
, qtimageformats

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
                 qtimageformats
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
    inherit (qtbase.meta) platforms;
    # Broken on hydra since 2020-08-15: https://hydra.nixos.org/build/125495291 (bump from 3.16 to 3.17 prerelease)
    broken = stdenv.isDarwin;
  };
}
