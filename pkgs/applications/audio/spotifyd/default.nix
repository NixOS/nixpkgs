{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl
, withALSA ? true, alsaLib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
}:

rustPlatform.buildRustPackage rec {
  name = "spotifyd-${version}";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "v${version}";
    sha256 = "0nmi33wvagmasxb59jwhlgdqlh8gfmqgwib16k1wx885qhx9yg30";
  };

  # buildRustPackage currently seems to have some problems with [replace]
  # directives in Cargo files (see #30742 and #47172), so don't use the
  # replacement.
  cargoPatches = [ ./noavxcrypto.patch ];

  cargoSha256 = "09vial0psmh39j20ikmfldidl505jnpfnqa8ybszrf2pvrhszsgq";

  cargoBuildFlags = [
    "--no-default-features"
    "--features"
    "${stdenv.lib.optionalString withALSA "alsa_backend,"}${stdenv.lib.optionalString withPulseAudio "pulseaudio_backend,"}${stdenv.lib.optionalString withPortAudio "portaudio_backend,"}"
  ];

  buildInputs = [ pkgconfig openssl ]
    ++ stdenv.lib.optional withALSA alsaLib
    ++ stdenv.lib.optional withPulseAudio libpulseaudio
    ++ stdenv.lib.optional withPortAudio portaudio;

  meta = with stdenv.lib; {
    description = "An open source Spotify client running as a UNIX daemon";
    homepage = https://github.com/Spotifyd/spotifyd;
    license = with licenses; [ gpl3 ];
    maintainers = [ maintainers.jmgrosen ];
    platforms = platforms.all;
  };
}
