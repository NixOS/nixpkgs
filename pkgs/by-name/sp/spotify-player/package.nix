{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  cmake,
  # deps for audio backends
  alsa-lib,
  libpulseaudio,
  portaudio,
  libjack2,
  SDL2,
  gst_all_1,
  dbus,
  fontconfig,
  libsixel,

  # build options
  withStreaming ? true,
  withDaemon ? true,
  withAudioBackend ? "rodio", # alsa, pulseaudio, rodio, portaudio, jackaudio, rodiojack, sdl
  withMediaControl ? true,
  withImage ? true,
  withNotify ? true,
  withSixel ? true,
  withFuzzy ? true,
  stdenv,
  makeBinaryWrapper,

  # passthru
  nix-update-script,
}:

assert lib.assertOneOf "withAudioBackend" withAudioBackend [
  ""
  "alsa"
  "pulseaudio"
  "rodio"
  "portaudio"
  "jackaudio"
  "rodiojack"
  "sdl"
  "gstreamer"
];

rustPlatform.buildRustPackage rec {
  pname = "spotify-player";
  version = "0.20.4";

  src = fetchFromGitHub {
    owner = "aome510";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-5N/zTkNgcIk/Ml11Oo+jyoO0r2Hh9SxFL+tdhD/1X/4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0vIhAJ3u+PfujUGI07fddDs33P35Q4CSDz1sMuQwVws=";

  nativeBuildInputs =
    [
      pkg-config
      cmake
      rustPlatform.bindgenHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      makeBinaryWrapper
    ];

  buildInputs =
    [
      openssl
      dbus
      fontconfig
    ]
    ++ lib.optionals withSixel [ libsixel ]
    ++ lib.optionals (withAudioBackend == "alsa") [ alsa-lib ]
    ++ lib.optionals (withAudioBackend == "pulseaudio") [ libpulseaudio ]
    ++ lib.optionals (withAudioBackend == "rodio" && stdenv.hostPlatform.isLinux) [ alsa-lib ]
    ++ lib.optionals (withAudioBackend == "portaudio") [ portaudio ]
    ++ lib.optionals (withAudioBackend == "jackaudio") [ libjack2 ]
    ++ lib.optionals (withAudioBackend == "rodiojack") [
      alsa-lib
      libjack2
    ]
    ++ lib.optionals (withAudioBackend == "sdl") [ SDL2 ]
    ++ lib.optionals (withAudioBackend == "gstreamer") [
      gst_all_1.gstreamer
      gst_all_1.gst-devtools
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
    ];

  buildNoDefaultFeatures = true;

  buildFeatures =
    [ ]
    ++ lib.optionals (withAudioBackend != "") [ "${withAudioBackend}-backend" ]
    ++ lib.optionals withMediaControl [ "media-control" ]
    ++ lib.optionals withImage [ "image" ]
    ++ lib.optionals withDaemon [ "daemon" ]
    ++ lib.optionals withNotify [ "notify" ]
    ++ lib.optionals withStreaming [ "streaming" ]
    ++ lib.optionals withSixel [ "sixel" ]
    ++ lib.optionals withFuzzy [ "fzf" ];

  # tries to access HOME only in aarch64-darwin environment when building mac-notification-sys
  preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    export HOME=$TMPDIR
  '';

  # sixel-sys is dynamically linked to libsixel
  postInstall = lib.optionals (stdenv.hostPlatform.isDarwin && withSixel) ''
    wrapProgram $out/bin/spotify_player \
      --prefix DYLD_LIBRARY_PATH : "${lib.makeLibraryPath [ libsixel ]}"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal spotify player that has feature parity with the official client";
    homepage = "https://github.com/aome510/spotify-player";
    changelog = "https://github.com/aome510/spotify-player/releases/tag/v${version}";
    mainProgram = "spotify_player";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dit7ya
      xyven1
      _71zenith
      caperren
    ];
  };
}
