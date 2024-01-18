{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, ncurses
, openssl
, Cocoa
, withALSA ? true, alsa-lib
, withClipboard ? true, libxcb, python3
, withCover ? false, ueberzug
, withPulseAudio ? false, libpulseaudio
, withPortAudio ? false, portaudio
, withMPRIS ? true, withNotify ? true, dbus
}:

rustPlatform.buildRustPackage rec {
  pname = "ncspot";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    hash = "sha256-NHrpJC6cF/YAcyqZ4bRQdSdjDNhkEV7U2P/S4LSADao=";
  };

  cargoHash = "sha256-HT084XewXwZByL5KZhyymqU7sy99SAjYIWysm3qGvWU=";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional withClipboard python3;

  buildInputs = [ ncurses ]
    ++ lib.optional stdenv.isLinux openssl
    ++ lib.optional withALSA alsa-lib
    ++ lib.optional withClipboard libxcb
    ++ lib.optional withCover ueberzug
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional (withMPRIS || withNotify) dbus
    ++ lib.optional stdenv.isDarwin Cocoa;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-DNCURSES_UNCTRL_H_incl";

  buildNoDefaultFeatures = true;

  buildFeatures = [ "cursive/pancurses-backend" ]
    ++ lib.optional withALSA "alsa_backend"
    ++ lib.optional withClipboard "share_clipboard"
    ++ lib.optional withCover "cover"
    ++ lib.optional withPulseAudio "pulseaudio_backend"
    ++ lib.optional withPortAudio "portaudio_backend"
    ++ lib.optional withMPRIS "mpris"
    ++ lib.optional withNotify "notify";

  meta = with lib; {
    description = "Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes";
    homepage = "https://github.com/hrkfdn/ncspot";
    changelog = "https://github.com/hrkfdn/ncspot/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
  };
}
