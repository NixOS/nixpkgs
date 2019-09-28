{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl
, withALSA ? true, alsaLib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "v${version}";
    sha256 = "097hg18h7gya2w0wl5jkav79nb3qzcc4ycsryq7nhxa0h1agvinc";
  };

  cargoSha256 = "0ar4bfwn3qxa6wsz2hd7nv1wr824h74jy3xqba2qsy0rsfwy1bmm";

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

  doCheck = false;

  meta = with stdenv.lib; {
    description = "An open source Spotify client running as a UNIX daemon";
    homepage = "https://github.com/Spotifyd/spotifyd";
    license = with licenses; [ gpl3 ];
    maintainers = [ maintainers.anderslundstedt ];
    platforms = platforms.unix;
  };
}
