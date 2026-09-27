{
  lib,
  SDL2,
  SDL2_image,
  alsa-lib,
  asio,
  cmake,
  fetchFromGitHub,
  fluidsynth,
  gitUpdater,
  glib,
  gtest,
  iir1,
  libGL,
  libGLU,
  libjack2,
  libmt32emu,
  libogg,
  libpng,
  libpulseaudio,
  libslirp,
  libsndfile,
  libtiff,
  libwebp,
  libx11,
  libxi,
  makeWrapper,
  opusfile,
  pkg-config,
  speexdsp,
  stdenv,
  testers,
  zlib-ng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dosbox-staging";
  version = "0.83.0";
  shortRev = "7b40053";

  src = fetchFromGitHub {
    owner = "dosbox-staging";
    repo = "dosbox-staging";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pDAJVuuOI0VktLFw+JGvoKWgxzRywmXoCo2JJlN0Ul8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    asio
    fluidsynth
    glib
    gtest
    iir1
    libGL
    libGLU
    libjack2
    libmt32emu
    libogg
    libpng
    libpulseaudio
    libslirp
    libsndfile
    libtiff
    libwebp
    libx11
    libxi
    opusfile
    speexdsp
    zlib-ng
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  outputs = [
    "out"
    "man"
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_LIBS" true)
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getInclude SDL2}/include/SDL2"
  ];

  # git rev-parse doesn't work, so manually set the hash
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "BUILD_GIT_HASH \"?\"" "BUILD_GIT_HASH \"${
        builtins.substring 0 5 finalAttrs.shortRev
      }\""
  '';

  # Rename binary, add a wrapper, and copy manual to avoid conflict with
  # original dosbox. Doing it this way allows us to work with frontends and
  # launchers that expect the binary to be named dosbox, but get out of the way
  # of vanilla dosbox if the user desires to install that as well.
  postFixup = ''
    mv $out/bin/dosbox $out/bin/dosbox-staging
    makeWrapper $out/bin/dosbox-staging $out/bin/dosbox
    mv $out/share/dosbox-staging/resources/* $out/share/dosbox-staging/

    pushd $man/share/man/man1/
    ln -s dosbox.1.gz dosbox-staging.1.gz
    popd
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "dosbox --version";
      };
    };
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    homepage = "https://dosbox-staging.github.io/";
    description = "Modernized DOS emulator; DOSBox fork";
    longDescription = ''
      DOSBox Staging is an attempt to revitalize DOSBox's development
      process. It's not a rewrite, but a continuation and improvement on the
      existing DOSBox codebase while leveraging modern development tools and
      practices.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      Zaechus
    ];
    platforms = lib.platforms.unix;
    priority = 101;
  };
})
