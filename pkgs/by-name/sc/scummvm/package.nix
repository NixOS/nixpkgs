{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_net,
  a52dec,
  alsa-lib,
  curl,
  discord-rpc,
  faad2,
  flac,
  fluidsynth,
  freetype,
  fribidi,
  giflib,
  gtk3,
  libGL,
  libGLU,
  libjpeg,
  libmad,
  libmpcdec,
  libmpeg2,
  libogg,
  libopenmpt,
  libpng,
  libtheora,
  libvorbis,
  libvpx,
  libx11,
  nasm,
  nix-update-script,
  pkg-config,
  python3,
  sndio,
  sonivox,
  speechd-minimal,
  versionCheckHook,
  zlib,

  withCloud ? true,
  withDiscord ? true,
  withFluidsynth ? true,
  withGtk ? stdenv.hostPlatform.isLinux,
  withNetworking ? true,
  withTTS ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scummvm";
  version = "2026.4.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "scummvm";
    repo = "scummvm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GBPfByKCWP4/YGRXMapM1oo0MzZZ2bAzFRu4DmZQMrI=";
  };

  nativeBuildInputs = [
    nasm
    pkg-config
  ];

  buildInputs = [
    SDL2
    a52dec
    faad2
    flac
    freetype
    fribidi
    giflib
    libjpeg
    libmad
    libmpcdec
    libmpeg2
    libogg
    libopenmpt
    libpng
    libtheora
    libvorbis
    libvpx
    libx11
    sndio
    sonivox
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libGL
    libGLU
  ]
  ++ lib.optional withCloud curl
  ++ lib.optional withDiscord discord-rpc
  ++ lib.optional withFluidsynth fluidsynth
  ++ lib.optional withGtk gtk3
  ++ lib.optional withNetworking SDL2_net
  ++ lib.optional (withTTS && stdenv.hostPlatform.isLinux) speechd-minimal;

  dontDisableStatic = true;
  enableParallelBuilding = true;

  configureFlags = [
    "--enable-release"
    "--with-sdl-prefix=${lib.getDev SDL2}"
  ]
  ++ (
    if withCloud then
      [ "--with-libcurl-prefix=${lib.getDev curl}" ]
    else
      [
        "--disable-cloud"
        "--disable-libcurl"
      ]
  )
  ++ lib.optional (!withDiscord) "--disable-discord"
  ++ lib.optional (!withFluidsynth) "--disable-fluidsynth"
  ++ lib.optional (!withGtk) "--disable-gtk"
  ++ lib.optional (!withNetworking) "--disable-sdlnet"
  ++ lib.optional (!withTTS) "--disable-tts";

  # They use 'install -s', that calls the native strip instead of the cross
  postConfigure = ''
    sed -i "s/-c -s/-c -s --strip-program=''${STRIP@Q}/" ports.mk
  '';

  doCheck = true;
  nativeCheckInputs = [ python3 ];
  checkTarget = "test";

  preCheck = ''
    patchShebangs --build test/cxxtest/bin/cxxtestgen
  '';

  doInstallCheck = !stdenv.hostPlatform.isDarwin;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = "SDL_VIDEODRIVER";

  preVersionCheck = ''
    export SDL_VIDEODRIVER=dummy
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    longDescription = ''
      ScummVM allows you to play classic graphic point-and-click adventure games,
      text adventure games, and RPGs. It reimplements the original
      engines (SCUMM, SCI, AGS, and many more) so those games can be played
      on systems and hardware they were never designed for.
    '';
    homepage = "https://www.scummvm.org/";
    changelog = "https://github.com/scummvm/scummvm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      keenanweaver
      peterhoeg
    ];
    platforms = lib.platforms.unix;
    mainProgram = "scummvm";
  };
})
