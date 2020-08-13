{ lib, fetchFromGitHub, rustPlatform, pkg-config, ncurses, openssl
, withALSA ? true, alsaLib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
, withMPRIS ? false, dbus ? null
}:

let
  features = [ "cursive/pancurses-backend" ]
    ++ lib.optional withALSA "alsa_backend"
    ++ lib.optional withPulseAudio "pulseaudio_backend"
    ++ lib.optional withPortAudio "portaudio_backend"
    ++ lib.optional withMPRIS "mpris";
in
rustPlatform.buildRustPackage rec {
  pname = "ncspot";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    sha256 = "1yx0fc24bgh1x6fdwznc1hqvjq0j7i0zvws3bsyijzs7q48jm0z7";
  };

  cargoSha256 = "0bh2shg80xbs2cw10dabrdxkvhf2csk5h9wmmk5z87q6w25paz1f";

  cargoBuildFlags = [ "--no-default-features" "--features" "${lib.concatStringsSep "," features}" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses openssl ]
    ++ lib.optional withALSA alsaLib
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional withMPRIS dbus;

  doCheck = false;

  meta = with lib; {
    description = "Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes";
    homepage = "https://github.com/hrkfdn/ncspot";
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
  };
}
