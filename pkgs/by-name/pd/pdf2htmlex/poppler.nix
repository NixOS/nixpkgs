{
  lib,
  stdenv,
  fetchFromGitLab,
  poppler,
  cmake,
  pkg-config,
  cairo,
  curl,
  fontconfig,
  freetype,
  lcms,
  libjpeg,
  openjpeg,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "poppler-${finalAttrs.version}-static";
  # Follow https://github.com/pdf2htmlEX/pdf2htmlEX/blob/v0.18.8.rc1/buildScripts/versionEnvs#L11
  version = "0.89.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "poppler";
    repo = "poppler";
    tag = "poppler-${finalAttrs.version}";
    hash = "sha256-I6hapmimQSueU+mcaH/RBtWENPqNeM9cMSZ139Q4j70=";
  };

  patches = [
    ./poppler-private.patch
  ];

  buildInputs = [
    cairo
    curl
    fontconfig
    freetype
    lcms
    libjpeg
    openjpeg
    zlib
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  # Follow https://github.com/pdf2htmlEX/pdf2htmlEX/blob/v0.18.8.rc1/buildScripts/buildPoppler
  cmakeFlags = with lib; [
    (cmakeBool "ENABLE_UNSTABLE_API_ABI_HEADERS" false)
    (cmakeBool "ENABLE_SPLASH" true)
    (cmakeBool "ENABLE_UTILS" false)
    (cmakeBool "ENABLE_CPP" false)
    (cmakeBool "ENABLE_GLIB" true)
    (cmakeBool "ENABLE_GOBJECT_INTROSPECTION" false)
    (cmakeBool "ENABLE_GTK_DOC" false)
    (cmakeBool "ENABLE_QT5" false)
    (cmakeFeature "ENABLE_LIBOPENJPEG" "none")
    (cmakeFeature "ENABLE_CMS" "none")
    (cmakeFeature "ENABLE_DCTDECODER" "libjpeg")
    (cmakeBool "ENABLE_LIBCURL" false)
    (cmakeBool "ENABLE_ZLIB" true)
    (cmakeBool "ENABLE_ZLIB_UNCOMPRESS" false)
    (cmakeBool "USE_FLOAT" false)
    (cmakeBool "BUILD_SHARED_LIBS" false)
    (cmakeBool "RUN_GPERF_IF_PRESENT" false)
    (cmakeBool "EXTRA_WARN" false)
    (cmakeBool "WITH_JPEG" true)
    (cmakeBool "WITH_PNG" true)
    (cmakeBool "WITH_TIFF" false)
    (cmakeBool "WITH_NSS3" false)
    (cmakeBool "WITH_Cairo" true)
  ];

  postInstall = ''
    cp -rv poppler/* $out/include/poppler/
  '';

  meta = poppler.meta // {
    maintainers = with lib.maintainers; [
      Cryolitia
    ];
  };
})
