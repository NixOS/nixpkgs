{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  nix-update-script,

  cmake,
  pkg-config,
  sphinx,

  lerc,
  libdeflate,
  libjpeg,
  libwebp,
  xz,
  zlib,
  zstd,

  # Because lerc is C++ and static libraries don't track dependencies, every downstream dependent of
  # libtiff has to link with a C++ compiler, or the C++ standard library won't be linked, resulting
  # in undefined symbol errors. Without systematic support for this in build systems, fixing this
  # would require modifying the build system of every libtiff user. Hopefully at some point build
  # systems will figure this out, and then we can enable this.
  #
  # See https://github.com/mesonbuild/meson/issues/14234
  withLerc ? !stdenv.hostPlatform.isStatic,

  # for passthru.tests
  libgeotiff,
  python3Packages,
  imagemagick,
  graphicsmagick,
  gdal,
  openimageio,
  freeimage,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtiff";
  version = "4.7.0";

  src = fetchFromGitLab {
    owner = "libtiff";
    repo = "libtiff";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SuK9/a6OUAumEe1kz1itFJGKxJzbmHkBVLMnyXhIwmQ=";
  };

  patches = [
    # Fix test_directory test on big-endian
    # https://gitlab.com/libtiff/libtiff/-/issues/652
    (fetchpatch {
      name = "0001-Update-test_directory-not-to-fail-on-big-endian-machines";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/e8233c42f2e0a0ea7260c3cc7ebbaec8e5cb5e07.patch";
      hash = "sha256-z5odG66j4U+WoUjTUuBIhcVUCGK1GYdvW/cVucawNZI=";
    })

    # libc++abi 11 has an `#include <version>`, this picks up files name
    # `version` in the project's include paths
    ./rename-version.patch
    (fetchpatch {
      name = "CVE-2024-13978_1.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/7be20ccaab97455f192de0ac561ceda7cd9e12d1.patch";
      hash = "sha256-cpsQyIvyP6LkGeQTlLX73iNd1AcPkvZ6Xqfns7G3JBc=";
    })
    (fetchpatch {
      name = "CVE-2024-13978_2.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/2ebfffb0e8836bfb1cd7d85c059cd285c59761a4.patch";
      hash = "sha256-cZlLTeB7/nvylf5SLzKF7g91aBERhZxpV5fmWEJVrX4=";
    })
    (fetchpatch {
      name = "CVE-2025-9165.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/ed141286a37f6e5ddafb5069347ff5d587e7a4e0.patch";
      hash = "sha256-DIsk8trbHMMTrj6jP5Ae8ciRjHV4CPHdWCN+VbeFnFo=";
    })
  ];

  postPatch = ''
    mv VERSION VERSION.txt
  '';

  outputs = [
    "bin"
    "dev"
    "dev_private"
    "out"
    "man"
    "doc"
  ];

  postFixup = ''
    mkdir -p $dev_private/include
    mv -t $dev_private/include \
      libtiff/tif_config.h \
      ../libtiff/tif_dir.h \
      ../libtiff/tif_hash_set.h \
      ../libtiff/tiffiop.h
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    sphinx
  ];

  buildInputs = [
    libdeflate
    libjpeg
    # libwebp depends on us; this will cause infinite recursion otherwise
    (libwebp.override { tiffSupport = false; })
    xz
    zlib
    zstd
  ]
  ++ lib.optionals withLerc [
    lerc
  ];

  cmakeFlags = [
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  # Avoid flakiness like https://gitlab.com/libtiff/libtiff/-/commit/94f6f7315b1
  enableParallelChecking = false;

  passthru = {
    tests = {
      inherit
        libgeotiff
        imagemagick
        graphicsmagick
        gdal
        openimageio
        freeimage
        ;

      inherit (python3Packages) pillow imread;

      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "https://libtiff.gitlab.io/libtiff";
    changelog = "https://libtiff.gitlab.io/libtiff/releases/v${finalAttrs.version}.html";
    license = licenses.libtiff;
    platforms = platforms.unix ++ platforms.windows;
    pkgConfigModules = [ "libtiff-4" ];
    teams = [ teams.geospatial ];
  };
})
