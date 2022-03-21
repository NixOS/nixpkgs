{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, ncurses, openssl, libiconv
, withALSA ? true, alsa-lib
, withPulseAudio ? false, libpulseaudio
, withPortAudio ? false, portaudio
, withMPRIS ? false, dbus
}:

rustPlatform.buildRustPackage rec {
  pname = "ncspot";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    sha256 = "sha256-HnP0dXKkMssDAhrsA99bTCVGdov9t5+1y8fJ+BWTM80=";
  };

  # Upstream now only supports rust 1.58+, but this version is not yet available in nixpkgs.
  # See https://github.com/hrkfdn/ncspot/issues/714
  patches = [ ./rust_1_57_support.patch ];

  cargoSha256 = "sha256-g6UMwirsSV+/NtFIfEZrz5h/OitPQcDeSawh7wq4TLI=";

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
