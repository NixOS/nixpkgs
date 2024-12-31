{
  lib,
  stdenv,
  config,
  fetchFromGitHub,
  rustPackages,
  pkg-config,
  openssl,
  withALSA ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  withJack ? stdenv.hostPlatform.isLinux,
  libjack2,
  withPulseAudio ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
  withPortAudio ? stdenv.hostPlatform.isDarwin,
  portaudio,
  withMpris ? stdenv.hostPlatform.isLinux,
  withKeyring ? true,
  dbus,
  withPipe ? true,
  nix-update-script,
  testers,
  spotifyd,
}:

rustPackages.rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.3.5-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "b25538f5c4dfc5b376927e7edf71c7c988492ace";
    hash = "sha256-50eUVax3yqwncQUWgCPc0PHVUuUERQ9iORSSajPHB9c=";
  };

  cargoHash = "sha256-3aEBLPyf72o9gF58j9OANpcqD/IClb2alfAEKRFzatU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optional (withALSA || withJack) alsa-lib
    ++ lib.optional withJack libjack2
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio
    # The `dbus_keying` feature works on other platforms, but only requires
    # `dbus` on Linux
    ++ lib.optional ((withMpris || withKeyring) && stdenv.hostPlatform.isLinux) dbus;

  buildNoDefaultFeatures = true;
  buildFeatures =
    lib.optional withALSA "alsa_backend"
    ++ lib.optional withJack "rodiojack_backend"
    ++ lib.optional withPulseAudio "pulseaudio_backend"
    ++ lib.optional withPortAudio "portaudio_backend"
    ++ lib.optional withMpris "dbus_mpris"
    ++ lib.optional withPipe "pipe_backend"
    ++ lib.optional withKeyring "dbus_keyring";

  doCheck = false;

  passthru = {
    tests.version = testers.testVersion {
      package = spotifyd;
      version = builtins.head (lib.splitString "-" version);
    };
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Open source Spotify client running as a UNIX daemon";
    homepage = "https://spotifyd.rs/";
    changelog = "https://github.com/Spotifyd/spotifyd/blob/${src.rev}/CHANGELOG.md";
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
