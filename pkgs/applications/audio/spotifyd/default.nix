{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl
, withALSA ? true, alsaLib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "${version}";
    sha256 = "1iybk9xrrvhrcl2xl5r2xhyn1ydhrgwnnb8ldhsw5c16b32z03q1";
  };

  cargoSha256 = "0879p1h32259schmy8j3xnwpw3sw80f8mrj8s6b5aihi3yyzz521";

  cargoBuildFlags = [
    "--no-default-features"
    "--features"
    "${stdenv.lib.optionalString withALSA "alsa_backend,"}${stdenv.lib.optionalString withPulseAudio "pulseaudio_backend,"}${stdenv.lib.optionalString withPortAudio "portaudio_backend,"}"
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optional withALSA alsaLib
    ++ stdenv.lib.optional withPulseAudio libpulseaudio
    ++ stdenv.lib.optional withPortAudio portaudio;

  meta = with stdenv.lib; {
    description = "An open source Spotify client running as a UNIX daemon";
    homepage = "https://github.com/Spotifyd/spotifyd";
    license = with licenses; [ gpl3 ];
    maintainers = [ maintainers.anderslundstedt ];
    platforms = platforms.unix;
  };
}
