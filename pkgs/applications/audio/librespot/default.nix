{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, withRodio ? true
, withALSA ? true, alsa-lib ? null, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null }:

rustPlatform.buildRustPackage rec {
  pname = "librespot";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "librespot-org";
    repo = "librespot";
    rev = "v${version}";
    sha256 = "153i9n3qwmmwc29f62cz8nbqrlry16iygvibm1sdnvpf0s6wk5f3";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "11d64rpq4b5rdxk5wx0hhzgc6mvs6h2br0w3kfncfklp67vn3v4v";

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
