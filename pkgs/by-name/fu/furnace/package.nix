{
  stdenv,
  lib,
  testers,
  furnace,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  fftw,
  fmt,
  freetype,
  libsndfile,
  libX11,
  rtmidi,
  SDL2,
  zlib,
  withJACK ? stdenv.hostPlatform.isUnix,
  libjack2,
  withGUI ? true,
  darwin,
  portaudio,
  alsa-lib,
  # Enable GL/GLES rendering
  withGL ? !stdenv.hostPlatform.isDarwin,
  # Use GLES instead of GL, some platforms have better support for one than the other
  preferGLES ? stdenv.hostPlatform.isAarch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "furnace";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "tildearrow";
    repo = "furnace";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-G5yjqsep+hDGXCqGNBKoMvV7JOD7ZZTxTPBl9VmG8RM=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    # To offer scaling detection on X11, furnace checks if libX11.so is available via dlopen and uses some of its functions
    # But it's being linked against a versioned libX11.so.VERSION via SDL, so the unversioned one is not on the rpath
    substituteInPlace src/gui/scaling.cpp \
      --replace-fail 'libX11.so' '${lib.getLib libX11}/lib/libX11.so'
  '';

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      makeWrapper
    ];

  buildInputs =
    [
      fftw
      fmt
      freetype
      libsndfile
      rtmidi
      SDL2
      zlib
      portaudio
    ]
    ++ lib.optionals withJACK [
      libjack2
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # portaudio pkg-config is pulling this in as a link dependency, not set in propagatedBuildInputs
      alsa-lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Cocoa
      ]
    );

  cmakeFlags = [
    (lib.cmakeBool "BUILD_GUI" withGUI)
    (lib.cmakeBool "SYSTEM_FFTW" true)
    (lib.cmakeBool "SYSTEM_FMT" true)
    (lib.cmakeBool "SYSTEM_LIBSNDFILE" true)
    (lib.cmakeBool "SYSTEM_RTMIDI" true)
    (lib.cmakeBool "SYSTEM_SDL2" true)
    (lib.cmakeBool "SYSTEM_ZLIB" true)
    (lib.cmakeBool "USE_FREETYPE" true)
    (lib.cmakeBool "SYSTEM_FREETYPE" true)
    (lib.cmakeBool "WITH_JACK" withJACK)
    (lib.cmakeBool "WITH_PORTAUDIO" true)
    (lib.cmakeBool "SYSTEM_PORTAUDIO" true)
    (lib.cmakeBool "WITH_RENDER_SDL" true)
    (lib.cmakeBool "WITH_RENDER_OPENGL" withGL)
    (lib.cmakeBool "USE_GLES" (withGL && preferGLES))
    (lib.cmakeBool "WITH_RENDER_METAL" false) # fails to build
    (lib.cmakeBool "WITH_RENDER_OPENGL1" (withGL && !preferGLES))
    (lib.cmakeBool "FORCE_APPLE_BIN" true)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Normal CMake install phase on Darwin only installs the binary, the user is expected to use CPack to build a
    # bundle. That adds alot of overhead for not much benefit (CPack is currently abit broken, and needs impure access
    # to /usr/bin/hdiutil). So we'll manually assemble & install everything instead.

    mkdir -p $out/{Applications/Furnace.app/Contents/{MacOS,Resources},share/{,doc,licenses}/furnace}
    mv $out/{bin,Applications/Furnace.app/Contents/MacOS}/furnace
    makeWrapper $out/{Applications/Furnace.app/Contents/MacOS,bin}/furnace

    install -m644 {../res,$out/Applications/Furnace.app/Contents}/Info.plist
    install -m644 ../res/icon.icns $out/Applications/Furnace.app/Contents/Resources/Furnace.icns
    install -m644 {..,$out/share/licenses/furnace}/LICENSE
    cp -r ../papers $out/share/doc/furnace/
    cp -r ../demos $out/share/furnace/
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = furnace;
    };
  };

  meta = {
    description = "Multi-system chiptune tracker compatible with DefleMask modules";
    homepage = "https://github.com/tildearrow/furnace";
    changelog = "https://github.com/tildearrow/furnace/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
    mainProgram = "furnace";
  };
})
