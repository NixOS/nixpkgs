{ lib, stdenv, fetchFromGitHub, rustPackages_1_45, pkgconfig, openssl
, withALSA ? true, alsaLib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
, withMpris ? false
, withKeyring ? false
, dbus ? null
}:

# rust >= 1.48 causes a panic within spotifyd on music playback. as long as
# there is no upstream fix for the issue we use an older version of rust.
# Upstream issue: https://github.com/Spotifyd/spotifyd/issues/719
rustPackages_1_45.rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.2.24";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "v${version}";
    sha256 = "08i0zm7kgprixqjpgaxk7xid1njgj6lmi896jf9fsjqzdzlblqk8";
  };

  cargoSha256 = "0200apqbx769ggjnjr0m72g61ikhml2xak5n1il2pvfx1yf5nw0n";

  cargoBuildFlags = [
    "--no-default-features"
    "--features"
    "${stdenv.lib.optionalString withALSA "alsa_backend,"}${stdenv.lib.optionalString withPulseAudio "pulseaudio_backend,"}${stdenv.lib.optionalString withPortAudio "portaudio_backend,"}${stdenv.lib.optionalString withMpris "dbus_mpris,"}${stdenv.lib.optionalString withKeyring "dbus_keyring,"}"
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optional withALSA alsaLib
    ++ stdenv.lib.optional withPulseAudio libpulseaudio
    ++ stdenv.lib.optional withPortAudio portaudio
    ++ stdenv.lib.optional (withMpris || withKeyring) dbus;

  doCheck = false;

  meta = with lib; {
    description = "An open source Spotify client running as a UNIX daemon";
    homepage = "https://github.com/Spotifyd/spotifyd";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ anderslundstedt Br1ght0ne marsam ];
    platforms = platforms.unix;
  };
}
