{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, withRodio ? true
, withALSA ? true, alsa-lib ? null, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null }:

rustPlatform.buildRustPackage rec {
  pname = "librespot";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "librespot-org";
    repo = "librespot";
    rev = "v${version}";
    sha256 = "0n7h690gplpp47gdj038g6ncgwr7wvwfkg00cbrbvxhv7kzqqa1f";
  };

  cargoSha256 = "0qakvpxvn84ppgs3qlsfan4flqkmjcgs698w25jasx9ymiv8wc3s";

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
