{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, ncurses, openssl, libiconv
, withALSA ? true, alsa-lib ? null
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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    sha256 = "0sgnd6n8j8lygmb9qvv6i2ir28fdsrpmzlviz7d0gbx684qj0zkc";
  };

  cargoSha256 = "0piipqf5y5bczbwkaplv6niqh3rp2di1gn7wwpd0gaa2cw7ylbb1";

  cargoBuildFlags = [ "--no-default-features" "--features" "${lib.concatStringsSep "," features}" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses openssl ]
    ++ lib.optional stdenv.isDarwin libiconv
    ++ lib.optional withALSA alsa-lib
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
