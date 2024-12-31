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
  avahi-compat,
}:

rustPlatform.buildRustPackage rec {
  pname = "librespot";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "librespot-org";
    repo = "librespot";
    rev = "v${version}";
    sha256 = "sha256-dGQDRb7fgIkXelZKa+PdodIs9DxbgEMlVGJjK/hU3Mo=";
  };

  cargoHash = "sha256-GScAUqALoocqvsHz4XgPytI8cl0hiuWjqaO/ItNo4v4=";

  nativeBuildInputs =
    [
      pkg-config
      makeWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      rustPlatform.bindgenHook
    ];

  buildInputs =
    [ openssl ]
    ++ lib.optional withALSA alsa-lib
    ++ lib.optional withAvahi avahi-compat
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional withPulseAudio libpulseaudio;

  buildNoDefaultFeatures = true;
  buildFeatures =
    lib.optional withRodio "rodio-backend"
    ++ lib.optional withALSA "alsa-backend"
    ++ lib.optional withAvahi "with-avahi"
    ++ lib.optional withPortAudio "portaudio-backend"
    ++ lib.optional withPulseAudio "pulseaudio-backend";

  postFixup = lib.optionalString withALSA ''
    wrapProgram "$out/bin/librespot" \
      --set ALSA_PLUGIN_DIR '${alsa-plugins}/lib/alsa-lib'
  '';

  meta = with lib; {
    description = "Open Source Spotify client library and playback daemon";
    mainProgram = "librespot";
    homepage = "https://github.com/librespot-org/librespot";
    changelog = "https://github.com/librespot-org/librespot/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ bennofs ];
  };
}
