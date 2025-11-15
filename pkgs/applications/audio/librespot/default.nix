{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  stdenv,
  openssl,
  withALSA ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  alsa-plugins,
  withPortAudio ? false,
  portaudio,
  withPulseAudio ? false,
  libpulseaudio,
  withRodio ? true,
  withAvahi ? false,
  withMDNS ? true,
  withDNS-SD ? false,
  avahi-compat,
  tlsBackend ? "native-tls", # "native-tls" "rustls-tls-native-roots" "rustls-tls-webpki-roots"
}:

rustPlatform.buildRustPackage rec {
  pname = "librespot";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "librespot-org";
    repo = "librespot";
    rev = "v${version}";
    hash = "sha256-twWndV6z5Cdivz7pfAJzdlIjddEiZPEFnTzipMczmJo=";
  };

  cargoHash = "sha256-Kf3w6tD/MQaXXegtiCkFbUcYwr4OMw6ipLxNLxJ2NTQ=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional withALSA alsa-lib
  ++ lib.optional withDNS-SD avahi-compat
  ++ lib.optional withPortAudio portaudio
  ++ lib.optional withPulseAudio libpulseaudio;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    tlsBackend
  ]
  ++ lib.optional withRodio "rodio-backend"
  ++ lib.optional withMDNS "with-libmdns"
  ++ lib.optional withDNS-SD "with-dns-sd"
  ++ lib.optional withALSA "alsa-backend"
  ++ lib.optional withAvahi "with-avahi"
  ++ lib.optional withPortAudio "portaudio-backend"
  ++ lib.optional withPulseAudio "pulseaudio-backend";

  postFixup = lib.optionalString withALSA ''
    wrapProgram "$out/bin/librespot" \
      --set ALSA_PLUGIN_DIR '${alsa-plugins}/lib/alsa-lib'
  '';

  meta = {
    description = "Open Source Spotify client library and playback daemon";
    mainProgram = "librespot";
    homepage = "https://github.com/librespot-org/librespot";
    changelog = "https://github.com/librespot-org/librespot/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ bennofs ];
  };
}
