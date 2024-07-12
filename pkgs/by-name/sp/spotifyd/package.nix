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
  testers,
  spotifyd,
}:

rustPackages.rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.3.5-unstable-2024-07-10";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "8fb0b9a5cce46d2e99e127881a04fb1986e58008";
    hash = "sha256-wEPdf5ylnmu/SqoaWHxAzIEUpdRhhZfdQ623zYzcU+s=";
  };

  cargoHash = "sha256-+xTmkp+hGzmz4XrfKqPCtlpsX8zLA8XgJWM1SPunjq4=";

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
