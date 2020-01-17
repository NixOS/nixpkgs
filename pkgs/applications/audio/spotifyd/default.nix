{ lib, fetchFromGitHub, rustPackages, pkg-config, openssl, dbus_libs
, withALSA ? true, alsaLib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
, withMpris ? false
, withKeyring ? false
, dbus ? null
}:

let
  features = ["dbus_mpris"
              "dbus_keyring"
             ]
             ++ lib.optional withALSA "alsa_backend"
             ++ lib.optional withPulseAudio "pulseaudio_backend"
             ++ lib.optional withPortAudio "portaudio_backend";

in rustPackages.rustPlatform.buildRustPackage rec {
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
    "--features" (lib.concatStringsSep "," features)
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl dbus_libs ]
    ++ lib.optional withALSA alsaLib
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional (withMpris || withKeyring) dbus;

  doCheck = false;

  meta = with lib; {
    description = "An open source Spotify client running as a UNIX daemon";
    homepage = "https://github.com/Spotifyd/spotifyd";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ anderslundstedt Br1ght0ne marsam ];
    platforms = platforms.unix;
  };
}
