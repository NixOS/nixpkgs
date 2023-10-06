{ stdenv
, lib
, gitUpdater
, testers
, furnace
, fetchFromGitHub
, cmake
, pkg-config
, makeWrapper
, fftw
, fmt_8
, libsndfile
, libX11
, rtmidi
, SDL2
, zlib
, withJACK ? stdenv.hostPlatform.isUnix
, libjack2
, withGUI ? true
, Cocoa
, portaudio
, alsa-lib
# Enable GL/GLES rendering
, withGL ? !stdenv.hostPlatform.isDarwin
# Use GLES instead of GL, some platforms have better support for one than the other
, preferGLES ? stdenv.hostPlatform.isAarch
}:

stdenv.mkDerivation rec {
  pname = "furnace";
  version = "0.6pre16";

  src = fetchFromGitHub {
    owner = "tildearrow";
    repo = "furnace";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-n66Bv8xB/0KMJYoMILxsaKoaX+E0OFGI3QGqhxKTFUQ=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    # To offer scaling detection on X11, furnace checks if libX11.so is available via dlopen and uses some of its functions
    # But it's being linked against a versioned libX11.so.VERSION via SDL, so the unversioned one is not on the rpath
    substituteInPlace src/gui/scaling.cpp \
      --replace 'libX11.so' '${lib.getLib libX11}/lib/libX11.so'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeWrapper
  ];

  buildInputs = [
    fftw
    fmt_8
    libsndfile
    rtmidi
    SDL2
    zlib
    portaudio
  ] ++ lib.optionals withJACK [
    libjack2
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    # portaudio pkg-config is pulling this in as a link dependency, not set in propagatedBuildInputs
    alsa-lib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
  ];

  cmakeFlags = [
    "-DBUILD_GUI=${if withGUI then "ON" else "OFF"}"
    "-DSYSTEM_FFTW=ON"
    "-DSYSTEM_FMT=ON"
    "-DSYSTEM_LIBSNDFILE=ON"
    "-DSYSTEM_RTMIDI=ON"
    "-DSYSTEM_SDL2=ON"
    "-DSYSTEM_ZLIB=ON"
    "-DSYSTEM_PORTAUDIO=ON"
    "-DWITH_JACK=${if withJACK then "ON" else "OFF"}"
    "-DWITH_PORTAUDIO=ON"
    "-DWITH_RENDER_SDL=ON"
    "-DWITH_RENDER_OPENGL=${lib.boolToString withGL}"
    "-DWARNINGS_ARE_ERRORS=ON"
  ] ++ lib.optionals withGL [
    "-DUSE_GLES=${lib.boolToString preferGLES}"
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
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
    tests.version = testers.testVersion {
      package = furnace;
    };
  };

  meta = with lib; {
    description = "Multi-system chiptune tracker compatible with DefleMask modules";
    homepage = "https://github.com/tildearrow/furnace";
    changelog = "https://github.com/tildearrow/furnace/releases/tag/v${version}";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
