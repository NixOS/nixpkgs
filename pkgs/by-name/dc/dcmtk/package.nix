{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
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
    (fetchurl {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/debian/3.6.9-4/debian/patches/01_dcmtk_3.6.0-1.patch";
      hash = "sha256-kDEZvPqcF8+PYID24srMoPSBPltmnGiJ67LHsLVcPYM=";
    })
    (fetchurl {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/debian/3.6.9-4/debian/patches/07_dont_export_all_executables.patch";
      hash = "sha256-5slFod+S7Yuj0u2CfTUw+MWZYuqQs4hgoGmh3KAUo+c=";
    })
    (fetchurl {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/debian/3.6.9-4/debian/patches/remove_version.patch";
      hash = "sha256-jcV2xQzKdNiBgcaFtaxdJpJCCSVOqGIsi/A4iqVM8U8=";
    })
    (fetchurl {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/debian/3.6.9-4/debian/patches/0007-CVE-2024-47796.patch";
      hash = "sha256-QYWgSbyIcOq3CVg2ynVSPCHBIrDj9uqX4ese1huoOoU=";
    })
    (fetchurl {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/debian/3.6.9-4/debian/patches/0008-CVE-2024-52333.patch";
      hash = "sha256-/4NdauuH0v6CPMh+duMM91wWfylp6l4L2LTO80dDh9g=";
    })
    (fetchurl {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/debian/3.6.9-4/debian/patches/0009-CVE-2025-25475.patch";
      hash = "sha256-ApuVw6aBoasuVlJ3fh/aufB2WRm2hFgLYCq1k3MPrsU=";
    })
    (fetchurl {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/debian/3.6.9-4/debian/patches/0010-CVE-2025-25474.patch";
      hash = "sha256-aX8em1o88ND4srsYkG696elPsAIlvkRRZMT8wzD2GdQ=";
    })
    (fetchurl {
      url = "https://salsa.debian.org/med-team/dcmtk/-/raw/debian/3.6.9-4/debian/patches/0011-CVE-2025-25472.patch";
      hash = "sha256-o3/PykJFbYlasAFgPNWp09hRuH183tQuvGuaOV4MOoo=";
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
