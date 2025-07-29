{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoctor,
  cmake,
  doxygen,
  pkg-config,
  alsa-lib,
  flac,
  fluidsynth,
  fmt,
  freetype,
  glib,
  harfbuzz,
  lhasa,
  libdecor,
  liblcf,
  libpng,
  libsndfile,
  libsysprof-capture,
  libvorbis,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libxmp,
  libXrandr,
  libXScrnSaver,
  libXxf86vm,
  mpg123,
  nlohmann_json,
  opusfile,
  pcre2,
  pixman,
  sdl3,
  speexdsp,
  wildmidi,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "easyrpg-player";
  # liblcf needs to be updated before this.
  version = "0.8.1.1";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "Player";
    rev = version;
    hash = "sha256-fYSpFhqETkQhRK1/Uws0fWWdCr35+1J4vCPX9ZiQ3ZA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    asciidoctor
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = [
    flac # needed by libsndfile
    fluidsynth
    fmt
    freetype
    glib
    harfbuzz
    lhasa
    liblcf
    libpng
    libsndfile
    libsysprof-capture # needed by glib
    libvorbis
    libxmp
    mpg123
    nlohmann_json
    opusfile
    pcre2 # needed by glib
    pixman
    sdl3
    speexdsp
    wildmidi
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXScrnSaver
    libXxf86vm
    libdecor
  ];

  cmakeFlags = [
    "-DPLAYER_ENABLE_TESTS=${lib.boolToString doCheck}"
    # TODO: remove the below once SDL3 becomes default next major release
    "-DPLAYER_TARGET_PLATFORM=SDL3"
  ];

  makeFlags = [
    "all"
    "man"
  ];

  buildFlags = lib.optionals doCheck [
    "test_runner_player"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/bin
    mv Package $out/Applications
    ln -s $out/{Applications/EasyRPG\ Player.app/Contents/MacOS,bin}/EasyRPG\ Player
  '';

  enableParallelChecking = true;
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    description = "RPG Maker 2000/2003 and EasyRPG games interpreter";
    homepage = "https://easyrpg.org/";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.all;
    mainProgram = lib.optionalString stdenv.hostPlatform.isDarwin "EasyRPG Player";
  };
}
