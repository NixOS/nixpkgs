{ lib, fetchFromGitHub, rustPackages, pkg-config, openssl
, withALSA ? true, alsa-lib
, withPulseAudio ? false, libpulseaudio
, withPortAudio ? false, portaudio
, withMpris ? false
, withKeyring ? false
, dbus
}:

rustPackages.rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "v${version}";
    sha256 = "1liql2wp7cx0x4ha1578wx3m4byd295m4ph268s05yw2wrnr3v6c";
  };

  cargoSha256 = "1plvqd55d1gj0ydimv3154pwgj2sh1fqx2182nw8akzdfmzg1150";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optional withALSA alsa-lib
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional (withMpris || withKeyring) dbus;

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional withALSA "alsa_backend"
    ++ lib.optional withPulseAudio "pulseaudio_backend"
    ++ lib.optional withPortAudio "portaudio_backend"
    ++ lib.optional withMpris "dbus_mpris"
    ++ lib.optional withKeyring "dbus_keyring";

  doCheck = false;

  meta = with lib; {
    description = "An open source Spotify client running as a UNIX daemon";
    homepage = "https://github.com/Spotifyd/spotifyd";
    changelog = "https://github.com/Spotifyd/spotifyd/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ anderslundstedt Br1ght0ne marsam ];
    platforms = platforms.unix;
  };
}
