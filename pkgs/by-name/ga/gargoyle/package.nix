{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fetchDebianPatch,
  cmake,
  pkg-config,
  fluidsynth,
  fmt,
  freetype,
  libjpeg,
  libopenmpt,
  libpng,
  libsndfile,
  libvorbis,
  mpg123,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gargoyle";
  version = "2026.1.1";

  src = fetchFromGitHub {
    owner = "garglk";
    repo = "garglk";
    tag = finalAttrs.version;
    hash = "sha256-cBFsxbXQa2xqCwW6Gd90vupAykkHvRjeM5yjA383doQ=";
  };

  patches = [
    (fetchDebianPatch {
      pname = "gargoyle-free";
      version = "2023.1+dfsg";
      debianRevision = "4";
      patch = "ftbfs_gcc14.patch";
      hash = "sha256-eMx/RlUpq5Ez+1L8VZo40Y3h2ZKkqiQEmKTlkZRMXnI=";
    })
    # Let the Qt interface find its fonts and themes on darwin
    # https://github.com/garglk/garglk/pull/1047
    (fetchpatch {
      url = "https://github.com/garglk/garglk/commit/c47fed652273b4bf24a8443639883855bbc8a97d.patch";
      hash = "sha256-F1JRCcCY+ZZUBBDwhxobTlFzeRjX+AeL3oxkwQYWzGQ=";
    })
    # Backport of the fixes for CVE-2026-131873 and CVE-2026-131874 in the Plus interpreter,
    # which upstream fixed with a rewrite in https://github.com/garglk/garglk/pull/1041
    ./plus-cve-2026-131873-131874.patch
  ];

  postPatch = ''
    substituteInPlace garglk/garglk.pc.in \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@" \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    fluidsynth
    fmt
    freetype
    libjpeg
    libopenmpt
    libpng
    libsndfile
    libvorbis
    mpg123
    qt6.qtbase
    qt6.qtmultimedia
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    qt6.qtwayland
  ];

  cmakeFlags = [
    (lib.cmakeFeature "INTERFACE" "QT")
    (lib.cmakeFeature "SOUND" "QT")
    (lib.cmakeBool "WITH_QT6" true)
  ];

  meta = {
    homepage = "http://ccxvii.net/gargoyle/";
    license = lib.licenses.gpl2Plus;
    description = "Interactive fiction interpreter GUI";
    mainProgram = "gargoyle";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ iedame ];
  };
})
