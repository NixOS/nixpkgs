{
  asio,
  cmake,
  curl,
  fetchFromGitHub,
  ffmpeg_7-headless,
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
  # Darwin Dependencies
  darwin,
  coreaudioSupport ? stdenv.hostPlatform.isDarwin,
}:

let
  ffmpeg = ffmpeg_7-headless;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "musikcube";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = "musikcube";
    rev = finalAttrs.version;
    hash = "sha512-Yqh35hyGzGZlh4UoHK0MGYBa+zugYJg3F+8F223saTdDChiX4cSncroSTexRyJVGm7EE8INNJoXg3HU6bZ08lA==";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
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
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
      pulseaudio
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Cocoa
        SystemConfiguration
      ]
    )
    ++ lib.optionals coreaudioSupport (with darwin.apple_sdk.frameworks; [ CoreAudio ])
    ++ lib.optionals sndioSupport [ sndio ]
    ++ lib.optionals pipewireSupport [ pipewire ];

  cmakeFlags = [ "-DDISABLE_STRIP=true" ];

  postFixup = lib.optionalString stdenv.isDarwin ''
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
