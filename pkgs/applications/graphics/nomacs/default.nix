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
  version = "3.12";

  src = fetchFromGitHub {
    owner = "nomacs";
    repo = "nomacs";
    rev = version;
    sha256 = "12582i5v85da7vwjxj8grj99hxg34ij5cn3b1578wspdfw1xfy1i";
  };

  patches = [
    ./nomacs-iostream.patch
    (fetchpatch {
      name = "darwin-less-restrictive-opencv.patch";
      url = "https://github.com/nomacs/nomacs/commit/d182fce4bcd9a25bd15e3de065ca67849a32458c.patch";
      sha256 = "0j6sviwrjn69nqf59hjn30c4j838h8az7rnlwcx8ymlb21vd9x2h";
      stripLen = 1;
    })
  ];

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
    homepage = https://nomacs.org;
    description = "Qt-based image viewer";
    maintainers = [maintainers.ahmedtd];
    license = licenses.gpl3Plus;
    repositories.git = https://github.com/nomacs/nomacs.git;
    inherit (qtbase.meta) platforms;
  };
}
