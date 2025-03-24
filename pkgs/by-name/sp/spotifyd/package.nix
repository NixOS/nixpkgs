{
  lib,
  stdenv,
  config,
  alsa-lib,
  apple-sdk_11,
  cmake,
  dbus,
  fetchFromGitHub,
  libjack2,
  libpulseaudio,
  nix-update-script,
  openssl,
  pkg-config,
  portaudio,
  rustPlatform,
  spotifyd,
  testers,
  withALSA ? stdenv.hostPlatform.isLinux,
  withJack ? stdenv.hostPlatform.isLinux,
  withMpris ? stdenv.hostPlatform.isLinux,
  withPortAudio ? stdenv.hostPlatform.isDarwin,
  withPulseAudio ? config.pulseaudio or stdenv.hostPlatform.isLinux,
}:

rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    tag = "v${version}";
    hash = "sha256-YBh5lcHXqYjyo/MjNNxnycY5AXjvlu+2gAzG6gM4Gjc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-waZ9XNYZ/scyMsNT7bZYqN4Ch4GbuQtwxAYaWTjNZwg=";

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    # The `dbus_mpris` feature works on other platforms, but only requires `dbus` on Linux
    ++ lib.optional (withMpris && stdenv.hostPlatform.isLinux) dbus
    ++ lib.optional (withALSA || withJack) alsa-lib
    ++ lib.optional withJack libjack2
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio;

  # `aws-lc-sys` fails with this enabled
  hardeningDisable = [ "strictoverflow" ];

  buildNoDefaultFeatures = true;
  buildFeatures =
    lib.optional withALSA "alsa_backend"
    ++ lib.optional withJack "rodiojack_backend"
    ++ lib.optional withMpris "dbus_mpris"
    ++ lib.optional withPortAudio "portaudio_backend"
    ++ lib.optional withPulseAudio "pulseaudio_backend";

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # `assertion failed: shell.is_some()`
    # Internally it's trying to query the user's shell through `dscl`. This is bad
    # https://github.com/Spotifyd/spotifyd/blob/8777c67988508d3623d3f6b81c9379fb071ac7dd/src/utils.rs#L45-L47
    "--skip=utils::tests::test_ffi_discovery"
  ];

  passthru = {
    tests.version = testers.testVersion { package = spotifyd; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open source Spotify client running as a UNIX daemon";
    homepage = "https://spotifyd.rs/";
    changelog = "https://github.com/Spotifyd/spotifyd/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      anderslundstedt
      Br1ght0ne
      getchoo
    ];
    platforms = lib.platforms.unix;
    mainProgram = "spotifyd";
  };
}
