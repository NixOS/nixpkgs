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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "v${version}";
    sha256 = "1a578h13iv8gqmskzlncfr42jlg5gp0zfcizv4wbd48y9hl8fh2l";
  };

  cargoSha256 = "07dxfc0csrnfl01p9vdrqvca9f574svlf37dk3dz8p6q08ki0n1z";

  cargoBuildFlags = [
    "--no-default-features"
    "--features"
    "${lib.optionalString withALSA "alsa_backend,"}${lib.optionalString withPulseAudio "pulseaudio_backend,"}${lib.optionalString withPortAudio "portaudio_backend,"}${lib.optionalString withMpris "dbus_mpris,"}${lib.optionalString withKeyring "dbus_keyring,"}"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optional withALSA alsa-lib
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional (withMpris || withKeyring) dbus;

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
