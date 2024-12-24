{
  lib,
  SDL2,
  SDL2_image,
  SDL2_net,
  alsa-lib,
  fetchFromGitHub,
  fetchpatch,
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
  makeWrapper,
  meson,
  ninja,
  opusfile,
  pkg-config,
  speexdsp,
  stdenv,
  testers,
  zlib-ng,
  apple-sdk_15,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dosbox-staging";
  version = "0.81.1";

  src = fetchFromGitHub {
    owner = "dosbox-staging";
    repo = "dosbox-staging";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XGssEyX+AVv7/ixgGTRtPFjsUSX0FT0fhP+TXsFl2fY=";
  };

  patches = [
    (fetchpatch {
      name = "darwin-allow-bypass-wraps.patch";
      url = "https://github.com/dosbox-staging/dosbox-staging/commit/9f0fc1dc762010e5f7471d01c504d817a066cae3.patch";
      hash = "sha256-IzxRE1Vr+M8I5hdy80UwebjJ5R1IlH9ymaYgs6VwAO4=";
    })
  ];

  nativeBuildInputs = [
    gtest
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    [
      SDL2
      SDL2_image
      SDL2_net
      fluidsynth
      glib
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
      opusfile
      speexdsp
      zlib-ng
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_15
      (darwinMinVersionHook "10.15") # from https://www.dosbox-staging.org/releases/macos/
    ];

  outputs = [ "out" "man" ];

  postInstall = ''
    install -Dm644 $src/contrib/linux/dosbox-staging.desktop $out/share/applications/
  '';

  # Rename binary, add a wrapper, and copy manual to avoid conflict with
  # original dosbox. Doing it this way allows us to work with frontends and
  # launchers that expect the binary to be named dosbox, but get out of the way
  # of vanilla dosbox if the user desires to install that as well.
  postFixup = ''
    mv $out/bin/dosbox $out/bin/dosbox-staging
    makeWrapper $out/bin/dosbox-staging $out/bin/dosbox

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
      joshuafern
      AndersonTorres
    ];
    platforms = lib.platforms.unix;
    priority = 101;
  };
})
