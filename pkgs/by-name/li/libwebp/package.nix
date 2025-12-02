{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  threadingSupport ? true, # multi-threading
  openglSupport ? false,
  libglut,
  libGL,
  libGLU, # OpenGL (required for vwebp)
  pngSupport ? true,
  libpng, # PNG image format
  jpegSupport ? true,
  libjpeg, # JPEG image format
  tiffSupport ? true,
  libtiff, # TIFF image format
  gifSupport ? true,
  giflib, # GIF image format
  swap16bitcspSupport ? false, # Byte swap for 16bit color spaces
  libwebpmuxSupport ? true, # Build libwebpmux

  # for passthru.tests
  gd,
  graphicsmagick,
  haskellPackages,
  imagemagick,
  imlib2,
  libjxl,
  opencv,
  python3,
  vips,
  testers,
  libwebp,
}:

stdenv.mkDerivation rec {
  pname = "libwebp";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "webmproject";
    repo = "libwebp";
    rev = "v${version}";
    hash = "sha256-7i4fGBTsTjAkBzCjVqXqX4n22j6dLgF/0mz4ajNA45U=";
  };

  patches = [
    # Fixes endianness-related behaviour in build result when targeting big-endian via CMake
    # https://groups.google.com/a/webmproject.org/g/webp-discuss/c/wvBsO8n8BKA/m/eKpxLuagAQAJ
    (fetchpatch {
      name = "0001-libwebp-Fix-endianness-with-CMake.patch";
      url = "https://github.com/webmproject/libwebp/commit/0e5f4ee3deaba5c4381877764005d981f652791f.patch";
      hash = "sha256-VNiLv1y3cjSDCNen9KxqbdrldI6EhshTSnsq8g9x8HA=";
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "WEBP_USE_THREAD" threadingSupport)
    (lib.cmakeBool "WEBP_BUILD_VWEBP" openglSupport)
    (lib.cmakeBool "WEBP_BUILD_IMG2WEBP" (pngSupport || jpegSupport || tiffSupport))
    (lib.cmakeBool "WEBP_BUILD_GIF2WEBP" gifSupport)
    (lib.cmakeBool "WEBP_BUILD_ANIM_UTILS" false) # Not installed
    (lib.cmakeBool "WEBP_BUILD_EXTRAS" false) # Not installed
    (lib.cmakeBool "WEBP_ENABLE_SWAP_16BIT_CSP" swap16bitcspSupport)
    (lib.cmakeBool "WEBP_BUILD_LIBWEBPMUX" libwebpmuxSupport)
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [ ]
    ++ lib.optionals openglSupport [
      libglut
      libGL
      libGLU
    ]
    ++ lib.optionals pngSupport [ libpng ]
    ++ lib.optionals jpegSupport [ libjpeg ]
    ++ lib.optionals tiffSupport [ libtiff ]
    ++ lib.optionals gifSupport [ giflib ];

  passthru.tests = {
    inherit
      gd
      graphicsmagick
      imagemagick
      imlib2
      libjxl
      opencv
      vips
      ;
    inherit (python3.pkgs) pillow imread;
    haskell-webp = haskellPackages.webp;
    pkg-config = testers.hasPkgConfigModules { package = libwebp; };
  };

  meta = with lib; {
    description = "Tools and library for the WebP image format";
    homepage = "https://developers.google.com/speed/webp/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ajs124 ];
    pkgConfigModules = [
      # configure_pkg_config() calls for these are unconditional
      "libwebp"
      "libwebpdecoder"
      "libwebpdemux"
      "libsharpyuv"
    ]
    ++ lib.optionals libwebpmuxSupport [
      "libwebpmux"
    ];
  };
}
