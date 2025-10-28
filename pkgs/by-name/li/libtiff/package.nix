{
  lib,
  stdenv,
  fetchFromGitLab,
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
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtiff";
  version = "4.7.1";

  src = fetchFromGitLab {
    owner = "libtiff";
    repo = "libtiff";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UiC6s86i7UavW86EKm74oPVlEacvoKmwW7KETjpnNaI=";
  };

  patches = [
    # libc++abi 11 has an `#include <version>`, this picks up files name
    # `version` in the project's include paths
    ./rename-version.patch
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
