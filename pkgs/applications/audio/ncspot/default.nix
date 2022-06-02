{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, ncurses, openssl, libiconv
, withALSA ? true, alsa-lib
, withPulseAudio ? false, libpulseaudio
, withPortAudio ? false, portaudio
, withMPRIS ? false, dbus
}:

rustPlatform.buildRustPackage rec {
  pname = "ncspot";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    sha256 = "sha256-lrEIFPi55aP9utAaMIFtqocpkbDXRJqS/jlGUtE26kE=";
  };

  cargoSha256 = "sha256-vkNGQ3SXKJpUqDZ4TfmlSleAPAOQnsEncE8475NLJ4M=";

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
