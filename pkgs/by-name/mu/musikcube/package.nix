{
  asio,
  cmake,
  curl,
  fetchFromGitHub,
  ffmpeg-headless,
  gnutls,
  lame,
  lib,
  libev,
  game-music-emu,
  libmicrohttpd,
  libopenmpt,
  mpg123,
  ncurses,
  pkg-config,
  portaudio,
  stdenv,
  taglib,
  # Linux Dependencies
  alsa-lib,
  pipewireSupport ? !stdenv.hostPlatform.isDarwin,
  pipewire,
  pulseaudio,
  sndioSupport ? true,
  sndio,
  systemd,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  coreaudioSupport ? stdenv.hostPlatform.isDarwin,
}:

let
  ffmpeg = ffmpeg-headless;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "musikcube";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = "musikcube";
    rev = finalAttrs.version;
    hash = "sha512-qmoFMDmI4rvb5PrGgGoPlMwllG9H0B5uL4Xve/yQ8reQvQKIOWnt9e9oMm7gKO8eFAvFXiJLWUTpD3lTxZk1mQ==";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    asio
    curl
    ffmpeg
    gnutls
    lame
    libev
    game-music-emu
    libmicrohttpd
    libopenmpt
    mpg123
    ncurses
    portaudio
    taglib
  ]
  ++ lib.optionals systemdSupport [ systemd ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    pulseaudio
  ]
  ++ lib.optionals sndioSupport [ sndio ]
  ++ lib.optionals pipewireSupport [ pipewire ];

  cmakeFlags = [ "-DDISABLE_STRIP=true" ];

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath $out/share/musikcube $out/share/musikcube/musikcube
    install_name_tool -add_rpath $out/share/musikcube $out/share/musikcube/musikcubed
  '';

  meta = {
    description = "Terminal-based music player, library, and streaming audio server";
    homepage = "https://musikcube.com/";
    maintainers = with lib.maintainers; [
      aanderse
      afh
    ];
    mainProgram = "musikcube";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
