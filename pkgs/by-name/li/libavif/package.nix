{
  lib,
  stdenv,
  fetchFromGitHub,
  libaom,
  cmake,
  pkg-config,
  zlib,
  libpng,
  libjpeg,
  libwebp,
  libxml2,
  dav1d,
  libyuv,
  gdk-pixbuf,
  makeWrapper,
  gtest,
}:

let
  gdkPixbufModuleDir = "${placeholder "out"}/${gdk-pixbuf.moduleDir}";
  gdkPixbufModuleFile = "${placeholder "out"}/${gdk-pixbuf.binaryDir}/avif-loaders.cache";

  libargparse = fetchFromGitHub {
    owner = "kmurray";
    repo = "libargparse";
    rev = "ee74d1b53bd680748af14e737378de57e2a0a954";
    hash = "sha256-8RzKNjnX+Bpr6keck5xQL1NdfqMGNLLOUfB+zz5Iac8=";
  };
in

stdenv.mkDerivation rec {
  pname = "libavif";
  version = "1.3.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "AOMediaCodec";
    repo = "libavif";
    rev = "v${version}";
    hash = "sha256-0J56wpXa2AVh9JUp5UY2kzWijNE3i253RKhpG5oDFJE=";
  };

  postPatch = ''
    substituteInPlace contrib/gdk-pixbuf/avif.thumbnailer.in \
      --replace-fail '@CMAKE_INSTALL_FULL_BINDIR@/gdk-pixbuf-thumbnailer' "$out/libexec/gdk-pixbuf-thumbnailer-avif"

    ln -s ${libargparse} ext/libargparse
  '';

  # reco: encode libaom slowest but best, decode dav1d fastest

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DAVIF_CODEC_AOM=SYSTEM" # best encoder (slow but small)
    "-DAVIF_CODEC_DAV1D=SYSTEM" # best decoder (fast)
    "-DAVIF_BUILD_APPS=ON"
    "-DAVIF_BUILD_GDK_PIXBUF=ON"
    "-DAVIF_LIBSHARPYUV=SYSTEM"
    "-DAVIF_LIBXML2=SYSTEM"
    "-DAVIF_BUILD_TESTS=ON"
    "-DAVIF_GTEST=SYSTEM"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gdk-pixbuf
    makeWrapper
  ];

  buildInputs = [
    gdk-pixbuf
    gtest
    zlib
    libpng
    libjpeg
    libwebp
    libxml2
  ];

  propagatedBuildInputs = [
    dav1d
    libaom
    libyuv
  ];

  env.PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = gdkPixbufModuleDir;

  doCheck = true;

  postInstall = ''
    GDK_PIXBUF_MODULEDIR=${gdkPixbufModuleDir} \
    GDK_PIXBUF_MODULE_FILE=${gdkPixbufModuleFile} \
    gdk-pixbuf-query-loaders --update-cache
  ''
  # Cross-compiled gdk-pixbuf doesn't support thumbnailers
  + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    mkdir -p "$out/bin"
    makeWrapper ${gdk-pixbuf}/bin/gdk-pixbuf-thumbnailer "$out/libexec/gdk-pixbuf-thumbnailer-avif" \
      --set GDK_PIXBUF_MODULE_FILE ${gdkPixbufModuleFile}
  '';

  postFixup = ''
    substituteInPlace $dev/lib/cmake/libavif/libavif-config.cmake \
      --replace-fail "_IMPORT_PREFIX \"$out\"" "_IMPORT_PREFIX \"$dev\""
  '';

  meta = {
    description = "C implementation of the AV1 Image File Format";
    longDescription = ''
      Libavif aims to be a friendly, portable C implementation of the
      AV1 Image File Format. It is a work-in-progress, but can already
      encode and decode all AOM supported YUV formats and bit depths
      (with alpha). It also features an encoder and a decoder
      (avifenc/avifdec).
    '';
    homepage = "https://github.com/AOMediaCodec/libavif";
    changelog = "https://github.com/AOMediaCodec/libavif/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ mkg20001 ];
    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
  };
}
