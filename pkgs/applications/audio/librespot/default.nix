{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, withRodio ? true
, withALSA ? true, alsaLib ? null, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null }:

rustPlatform.buildRustPackage rec {
  pname = "librespot";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "librespot-org";
    repo = "librespot";
    rev = "v${version}";
    sha256 = "1ixh47yvaamrpzagqsiimc3y6bi4nbym95843d23am55zkrgnmy5";
  };

  cargoSha256 = "1g1y6v5xjahzgx5bfch77k4rg35igs1srzjp02lysi5ny89f331l";

  cargoPatches = [ ./cargo-lock.patch ];

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

  buildInputs = [ openssl ] ++ lib.optional withALSA alsaLib
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
