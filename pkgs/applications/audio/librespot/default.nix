{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, withRodio ? true
, withALSA ? true, alsa-lib ? null, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null }:

rustPlatform.buildRustPackage rec {
  pname = "librespot";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "librespot-org";
    repo = "librespot";
    rev = "v${version}";
    sha256 = "1fv2sk89rf1vraq823bxddlxj6b4gqhfpc36xr7ibz2405zickfv";
  };

  cargoSha256 = "1sal85gsbnrabxi39298w9njdc08csnwl40akd6k9fsc0fmpn1b0";

  cargoBuildFlags = with lib; [
    "--no-default-features"
    "--features"
    (concatStringsSep "," (filter (x: x != "") [
      (optionalString withRodio "rodio-backend")
      (optionalString withALSA "alsa-backend")
      (optionalString withPulseAudio "pulseaudio-backend")
      (optionalString withPortAudio "portaudio-backend")

    ]))
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional withALSA alsa-lib
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio;

  doCheck = false;

  meta = with lib; {
    description = "Open Source Spotify client library and playback daemon";
    homepage = "https://github.com/librespot-org/librespot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ bennofs ];
    platforms = platforms.unix;
  };
}
