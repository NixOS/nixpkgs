{ lib, fetchFromGitHub, rustPackages_1_45, pkg-config, openssl
, withALSA ? true, alsaLib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
, withMpris ? false
, withKeyring ? false
, dbus ? null
}:

rustPackages_1_45.rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "v${version}";
    sha256 = "055njhy9if4qpsbgbr6615xxhcx9plava1m4l323vi4dbw09wh5r";
  };

  cargoSha256 = "1ijrl208607abjwpr3cajcbj6sr35bk6ik778a58zf28kzdhrawc";

  cargoBuildFlags = [
    "--no-default-features"
    "--features"
    "${lib.optionalString withALSA "alsa_backend,"}${lib.optionalString withPulseAudio "pulseaudio_backend,"}${lib.optionalString withPortAudio "portaudio_backend,"}${lib.optionalString withMpris "dbus_mpris,"}${lib.optionalString withKeyring "dbus_keyring,"}"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optional withALSA alsaLib
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional (withMpris || withKeyring) dbus;

  doCheck = false;

  meta = with lib; {
    description = "An open source Spotify client running as a UNIX daemon";
    homepage = "https://github.com/Spotifyd/spotifyd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ anderslundstedt Br1ght0ne marsam ];
    platforms = platforms.unix;
  };
}
