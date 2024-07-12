{
  lib,
  stdenv,
  config,
  fetchFromGitHub,
  rustPackages,
  pkg-config,
  openssl,
  withALSA ? stdenv.isLinux,
  alsa-lib,
  withPulseAudio ? config.pulseaudio or stdenv.isLinux,
  libpulseaudio,
  withPortAudio ? stdenv.isDarwin,
  portaudio,
  withMpris ? stdenv.isLinux,
  withKeyring ? false,
  dbus,
  nix-update-script,
}:

rustPackages.rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.3.5-unstable-2024-02-18";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "ff2f7a06e54bf05afd57a0243dc9f67abc15f040";
    hash = "sha256-nebAd4a+ht+blRP52OF830/Dm15ZPwRL4IPWmmT9ViM=";
  };

  cargoHash = "sha256-6BRIMTrWTwvX3yIGEYEvigMT+n4EtaruMdrej2Dd49w=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optional withALSA alsa-lib
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional (withMpris || withKeyring) dbus;

  buildNoDefaultFeatures = true;
  buildFeatures =
    lib.optional withALSA "alsa_backend"
    ++ lib.optional withPulseAudio "pulseaudio_backend"
    ++ lib.optional withPortAudio "portaudio_backend"
    ++ lib.optional withMpris "dbus_mpris"
    ++ lib.optional withKeyring "dbus_keyring";

  doCheck = false;

  passthru = {
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
    ];
    platforms = lib.platforms.unix;
    mainProgram = "spotifyd";
  };
}
