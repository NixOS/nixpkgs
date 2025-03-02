{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  zlib,
  libtiff,
  libxml2,
  openssl,
  libiconv,
  libpng,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "dcmtk";
  version = "3.6.9";

  src = fetchFromGitHub {
    owner = "DCMTK";
    repo = "dcmtk";
    tag = "DCMTK-${version}";
    hash = "sha256-mdI/YqM38WhnCbsylIlmqLLWC5/QR+a8Wn9CNcN7KXU=";
  };

  # The following patches are taken from the Debian package
  # See https://salsa.debian.org/med-team/dcmtk
  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/master/debian/patches/01_dcmtk_3.6.0-1.patch";
      hash = "sha256-QHdm7HORy9xhVqCj6dH0mbcDZISpfyFth2H9bl3L7tI=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/master/debian/patches/07_dont_export_all_executables.patch";
      hash = "sha256-qrjf/d5ILXCvJKYA+12w+rP6fcAjcEU1jlaq9TaNNLE=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/master/debian/patches/remove_version.patch";
      hash = "sha256-EAgmrR7jN+krzA0kKVQZRefKO0hU3/x8v1sTSYbEc44=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/master/debian/patches/0007-CVE-2024-47796.patch";
      hash = "sha256-lXadDWpwDDT19OuBMwSC9KMNOV6o/Gx39XodG8v6h4s=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/master/debian/patches/0008-CVE-2024-52333.patch";
      hash = "sha256-e42IU6ZjjA9a8uW3KSKz8hJa+KeGKXg4yodq3vljStM=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/master/debian/patches/0009-CVE-2025-25475.patch";
      hash = "sha256-wmvpqteJCOQMkbMdRDclEEyGVFcr0dBEIe+ZHrNRESg=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/master/debian/patches/0010-CVE-2025-25474.patch";
      hash = "sha256-SUeUdpwhSxBYEoNpf5wHCo8i1ZRF+AxwUtM/6cMs41o=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/master/debian/patches/0011-CVE-2025-25472.patch";
      hash = "sha256-PzrA1UVxwtK0AWCEhSfH3Z+/DCoEXW03OAqT4zqVTQM=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libpng
    zlib
    libtiff
    libxml2
    openssl
    libiconv
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
    (lib.cmakeBool "CMAKE_SKIP_RPATH" true)
    "-DCMAKE_VERBOSE_MAKEFILE=ON"
    (lib.cmakeBool "DCMTK_ENABLE_PRIVATE_TAGS" true)
    (lib.cmakeBool "DCMTK_ENABLE_STL" true)
    (lib.cmakeBool "DCMTK_WITH_ICONV" true)
    (lib.cmakeBool "DCMTK_WITH_ICU" true)
    (lib.cmakeBool "DCMTK_WITH_OPENSSL" true)
    (lib.cmakeBool "DCMTK_WITH_TIFF" true)
    (lib.cmakeBool "DCMTK_WITH_XML" true)
    (lib.cmakeBool "DCMTK_WITH_ZLIB" true)
    (lib.cmakeBool "USE_COMPILER_HIDDEN_VISIBILITY" true)
    (lib.cmakeBool "BUILD_TESTING" false)
  ];

  doCheck = true;

  meta = {
    description = "Collection of libraries and applications implementing large parts of the DICOM standard";
    longDescription = ''
      DCMTK is a collection of libraries and applications implementing large parts of the DICOM standard.
      It includes software for examining, constructing and converting DICOM image files, handling offline media,
      sending and receiving images over a network connection, as well as demonstrative image storage and worklist servers.
      DCMTK is is written in a mixture of ANSI C and C++.
      It comes in complete source code and is made available as "open source" software.
    '';
    homepage = "https://dicom.offis.de/dcmtk";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iimog ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
