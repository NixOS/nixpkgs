{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl
, withRodio ? true
, withALSA ? true, alsaLib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "librespot";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "librespot-org";
    repo = "librespot";
    rev = "v${version}";
    sha256 = "1sdbjv8w2mfpv82rx5iy4s532l1767vmlrg9d8khnvh8vrm2lshy";
  };

  cargoSha256 = "0zi50imjvalwl6pxl35qrmbg74j5xdfaws8v69am4g9agbfjvlms";

  cargoBuildFlags = with stdenv.lib; [
    "--no-default-features"
    "--features"
    (concatStringsSep "," (filter (x: x != "") [
      (optionalString withRodio "rodio-backend")
      (optionalString withALSA "alsa-backend")
      (optionalString withPulseAudio "pulseaudio-backend")
      (optionalString withPortAudio "portaudio-backend")

    ]))
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optional withALSA alsaLib
    ++ stdenv.lib.optional withPulseAudio libpulseaudio
    ++ stdenv.lib.optional withPortAudio portaudio;

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Open Source Spotify client library and playback daemon";
    homepage = "https://github.com/librespot-org/librespot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ bennofs ];
    platforms = platforms.unix;
  };
}
