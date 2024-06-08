{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_image,
  SDL2_net,
  alsa-lib,
  darwin,
  fluidsynth,
  glib,
  gtest,
  iir1,
  libGL,
  libGLU,
  libjack2,
  libmt32emu,
  libogg,
  libpng,
  zlib-ng,
  libpulseaudio,
  libslirp,
  libsndfile,
  makeWrapper,
  meson,
  ninja,
  opusfile,
  pkg-config,
  speexdsp,
  nix-update-script,
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

  nativeBuildInputs = [
    gtest
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    [
      fluidsynth
      glib
      iir1
      libGL
      libGLU
      libjack2
      libmt32emu
      libogg
      libpng
      zlib-ng
      libpulseaudio
      libslirp
      libsndfile
      opusfile
      SDL2
      SDL2_image
      SDL2_net
      speexdsp
    ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AudioUnit
        Carbon
        Cocoa
      ]
    );

  postInstall = ''
    install -Dm644 $src/contrib/linux/dosbox-staging.desktop $out/share/applications/
  '';

  postFixup = ''
    # Rename binary, add a wrapper, and copy manual to avoid conflict with
    # original dosbox. Doing it this way allows us to work with frontends and
    # launchers that expect the binary to be named dosbox, but get out of the
    # way of vanilla dosbox if the user desires to install that as well.
    mv $out/bin/dosbox $out/bin/dosbox-staging
    makeWrapper $out/bin/dosbox-staging $out/bin/dosbox

    # Create a symlink to dosbox manual instead of copying it
    pushd $out/share/man/man1/
    ln -s dosbox.1.gz dosbox-staging.1.gz
    popd
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://dosbox-staging.github.io/";
    description = "A modernized DOS emulator";
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
