{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  xa,
  perl,
  hexdump,
  shared-mime-info,
  desktop-file-utils,
  ncurses,
  zlib,
  bzip2,
  sdl3,
  freetype,
  libdiscid,
  libpng,
  libjpeg_turbo,
  libogg,
  libvorbis,
  libopus,
  game-music-emu,
  libmad,
  flac,
  cjson,
  alsa-lib,
  speex,
  wavpack,
  ancient,
  unifont,
  unifont-csur,
  unifont_upper,

  withDefaultSoundfont ? true,
  timidity,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocp";
  version = "3.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mywave82";
    repo = "opencubicplayer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9LY4yIWdzfy6eHBX0Jkv2814+BBwzGVvY/cZwdV3naA=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    xa
    perl
    hexdump
    shared-mime-info
    desktop-file-utils
  ];

  buildInputs = [
    ncurses
    zlib
    bzip2
    sdl3
    freetype
    libdiscid
    libpng
    libjpeg_turbo
    libogg
    libvorbis
    libopus
    game-music-emu
    libmad
    flac
    cjson
    alsa-lib
    speex
    wavpack
    ancient
  ];

  configureFlags = [
    "--with-builtin=core"
    "--without-update-desktop-database"
    "--with-unifont-otf=${unifont}/share/fonts/opentype/unifont.otf"
    "--with-unifont-csur-ttf=${unifont-csur}/share/fonts/truetype/unifont_csur.ttf"
    "--with-unifont-upper-otf=${unifont_upper}/share/fonts/opentype/unifont_upper.otf"
  ]
  ++ lib.optionals withDefaultSoundfont [
    "--with-timidity-default-path=${timidity}/share/timidity"
  ];

  postPatch = ''
    patchShebangs --build playsndh/psgplay-git/script/tos
  '';

  meta = {
    description = "Text-based music file player";
    longDescription = ''
      Open Cubic Player plays and visualizes various tracked
      music formats (Amiga modules, S3M, IT), chiptunes and other
      formats related to the demoscene. Visual output can be done through
      nCurses, Linux console (VCSA + FrameBuffer) or SDL.
    '';
    homepage = "https://github.com/mywave82/opencubicplayer";
    changelog = "https://github.com/mywave82/opencubicplayer/blob/v${finalAttrs.version}/Changelog";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ treierxyz ];
    mainProgram = "ocp";
  };
})
