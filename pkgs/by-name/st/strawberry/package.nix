{
  alsa-lib,
  boost,
  chromaprint,
  cmake,
  fetchFromGitHub,
  fftw,
  glib-networking,
  gnutls,
  gst_all_1,
  kdsingleapplication,
  lib,
  libXdmcp,
  libcdio,
  libebur128,
  libidn2,
  libmtp,
  libpthreadstubs,
  libpulseaudio,
  libselinux,
  libsepol,
  libtasn1,
  ninja,
  nix-update-script,
  p11-kit,
  pkg-config,
  qt6,
  sqlite,
  stdenv,
  taglib,
  util-linux,
  sparsehash,
  rapidjson,

  # tests
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "strawberry";
  version = "1.2.13";

  src = fetchFromGitHub {
    owner = "jonaski";
    repo = "strawberry";
    rev = finalAttrs.finalPackage.version;
    hash = "sha256-0peM1d8ks4yYwK9+3bUf713MjEzI25TSexyFIP/r3b0=";
  };

  # the big strawberry shown in the context menu is *very* much in your face, so use the grey version instead
  postPatch = ''
    substituteInPlace src/context/contextalbum.cpp \
      --replace-fail pictures/strawberry.png pictures/strawberry-grey.png
  '';

  buildInputs = [
    alsa-lib
    boost
    chromaprint
    fftw
    gnutls
    kdsingleapplication
    libXdmcp
    libcdio
    libebur128
    libidn2
    libmtp
    libpthreadstubs
    libtasn1
    qt6.qtbase
    sqlite
    taglib
    sparsehash
    rapidjson
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
    libselinux
    libsepol
    p11-kit
  ]
  ++ (with gst_all_1; [
    glib-networking
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    util-linux
  ];

  cmakeFlags = [ (lib.cmakeBool "ENABLE_GPOD" false) ];

  checkInputs = [ gtest ];
  checkTarget = "strawberry_tests";
  preCheck = ''
    # defaults to "xcb" otherwise, which requires a display
    export QT_QPA_PLATFORM=offscreen
  '';
  doCheck = true;

  postInstall = ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      --prefix GIO_EXTRA_MODULES : "${glib-networking.out}/lib/gio/modules"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Music player and music collection organizer";
    homepage = "https://www.strawberrymusicplayer.org/";
    changelog = "https://raw.githubusercontent.com/jonaski/strawberry/${finalAttrs.finalPackage.version}/Changelog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    # upstream says darwin should work but they lack maintainers as of 0.6.6
    platforms = lib.platforms.linux;
    mainProgram = "strawberry";
  };
})
