{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  autoconf,
  automake,
  libtool,
  pkg-config,
  boost,
  cairo,
  fuse,
  glib,
  libarchive,
  librsvg,
  squashfuse,
  xdg-utils-cxx,
  xz, # for liblzma
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "libappimage";
  version = "1.0.4-5";

  src = fetchFromGitHub {
    owner = "AppImageCommunity";
    repo = "libappimage";
    rev = "v${version}";
    hash = "sha256-V9Ilo0zFo9Urke+jCA4CSQB5tpzLC/S5jmon+bA+TEU=";
  };

  patches = [
    # Fix build with GCC 13
    # FIXME: remove in next release
    (fetchpatch {
      url = "https://github.com/AppImageCommunity/libappimage/commit/1e0515b23b90588ce406669134feca56ddcbbe43.patch";
      hash = "sha256-WIMvXNqC1stgPiBTRpXHWq3edIRnQomtRSW2qO52TRo=";
    })

    # we really just want this for cmake 4 compatibility
    (fetchpatch {
      name = "libappimage-use-system-gtest.patch";
      url = "https://github.com/AppImageCommunity/libappimage/commit/7b83b7247fd2d86c330e09f534c9cec1b03f649f.patch";
      excludes = [
        "ci/*"
        "lib/gtest"
        "tests/*"
      ];
      hash = "sha256-H+ph5TfKJPFcAzw2c7pzmqvB9R50HtZP/DbroOxLTVU=";
    })
    (fetchpatch {
      name = "libappimage-fix-cmake-4.patch";
      url = "https://github.com/AppImageCommunity/libappimage/commit/e5f6ea562611d534dc8e899a12ddf15c50e820be.patch";
      hash = "sha256-P6fPoiqVX3TrKGrU2EXIMBpQLGl7xNcy41Iq7vRM+n8=";
    })
  ];

  postPatch = ''
    substituteInPlace cmake/libappimage.pc.in \
      --replace 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' 'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_BOOST=1"
    "-DUSE_SYSTEM_LIBARCHIVE=1"
    "-DUSE_SYSTEM_SQUASHFUSE=1"
    "-DUSE_SYSTEM_XDGUTILS=1"
    "-DUSE_SYSTEM_XZ=1"
  ];

  nativeBuildInputs = [
    cmake
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    boost
    fuse
    libarchive
    squashfuse
    xdg-utils-cxx
    xz
  ];

  propagatedBuildInputs = [
    cairo
    glib
    librsvg
    zlib
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Implements functionality for dealing with AppImage files";
    homepage = "https://github.com/AppImageCommunity/libappimage/";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.linux;
  };
}
