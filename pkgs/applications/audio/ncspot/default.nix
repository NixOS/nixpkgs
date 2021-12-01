{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, ncurses, openssl, libiconv
, withALSA ? true, alsa-lib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
, withMPRIS ? false, dbus ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "ncspot";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    sha256 = "sha256-fZ0yQGLGnEFxt+OiG9J+niYzvttybudfciu5xo104Qo=";
  };

  cargoSha256 = "sha256-i3/96rVfP8TbIz3pNArTp8w27rfp1aPhohfFMMHgubo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses openssl ]
    ++ lib.optional stdenv.isDarwin libiconv
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
