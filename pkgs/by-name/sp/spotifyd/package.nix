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
  version = "0.3.5-unstable-2024-12-27";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "c6e6af449b75225224158aeeef64de485db1139e";
    hash = "sha256-0HDrnEeqynb4vtJBnXyItprJkP+ZOAKIBP68Ht9xr2c=";
  };

  cargoHash = "sha256-bRO7cK+BlAUEr6DlK7GSJf/WNoCM4SYq/lZ8e9ENJZw=";

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
