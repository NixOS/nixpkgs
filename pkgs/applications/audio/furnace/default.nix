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
}:

stdenv.mkDerivation rec {
  pname = "furnace";
  version = "0.6pre7";

  src = fetchFromGitHub {
    owner = "tildearrow";
    repo = "furnace";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-Gr4XDfYaRUFdtnCJ6i0oRDszwAZYVW6Mbj4Sp7El5+8=";
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
  ] ++ lib.optionals withJACK [
    libjack2
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
    "-DWITH_JACK=${if withJACK then "ON" else "OFF"}"
    "-DWARNINGS_ARE_ERRORS=ON"
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
    # Needed with GCC 12 but breaks on darwin (with clang) or aarch64 (old gcc)
    "-Wno-error=mismatched-new-delete"
    "-Wno-error=use-after-free"
  ]);

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
