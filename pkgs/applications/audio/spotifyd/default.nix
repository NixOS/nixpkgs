{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPackages,
  pkg-config,
  openssl,
  withALSA ? true,
  alsa-lib,
  withPulseAudio ? false,
  libpulseaudio,
  withPortAudio ? false,
  portaudio,
  withMpris ? false,
  withKeyring ? false,
  dbus,
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

  meta = with lib; {
    description = "An open source Spotify client running as a UNIX daemon";
    homepage = "https://spotifyd.rs/";
    changelog = "https://github.com/Spotifyd/spotifyd/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      anderslundstedt
      Br1ght0ne
    ];
    platforms = platforms.unix;
    mainProgram = "spotifyd";
  };
}
