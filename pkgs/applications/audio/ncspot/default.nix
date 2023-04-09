{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, ncurses, openssl
, withALSA ? true, alsa-lib
, withPulseAudio ? false, libpulseaudio
, withPortAudio ? false, portaudio
, withMPRIS ? false, dbus
}:

rustPlatform.buildRustPackage rec {
  pname = "ncspot";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    hash = "sha256-TZTADhoJloqMSO2UgbwwvJoZqhi8UC1qNDDNxE6Aq54=";
  };

  cargoHash = "sha256-tEk7BxAN8jEquJiv89vC0lYrB/sKeZhThBzs09A9NpA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses ]
    ++ lib.optional stdenv.isLinux openssl
    ++ lib.optional withALSA alsa-lib
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional withMPRIS dbus;

  buildNoDefaultFeatures = true;
  buildFeatures = [ "cursive/pancurses-backend" ]
    ++ lib.optional withALSA "alsa_backend"
    ++ lib.optional withPulseAudio "pulseaudio_backend"
    ++ lib.optional withPortAudio "portaudio_backend"
    ++ lib.optional withMPRIS "mpris";

  doCheck = false;

  meta = with lib; {
    description = "Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes";
    homepage = "https://github.com/hrkfdn/ncspot";
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
  };
}
