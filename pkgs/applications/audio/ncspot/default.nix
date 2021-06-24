{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, ncurses, openssl, libiconv
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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    sha256 = "0j4ax3yh0l8v5bd5i3ijd8ys27dcrh7byigjip52mw1qlqfnh8wk";
  };

  cargoSha256 = "022q6rlac97dr6l7rd9xalgx0w257r364i1pij080qx8rk97msb9";

  cargoBuildFlags = [ "--no-default-features" "--features" "${lib.concatStringsSep "," features}" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses openssl ]
    ++ lib.optional stdenv.isDarwin libiconv
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
