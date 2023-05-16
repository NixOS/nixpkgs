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
<<<<<<< HEAD
  version = "0.13.4";
=======
  version = "0.13.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pYPUYy/ODzg9HN0/PTGZkV1NFBPmluhEwoJjYuZ6DTg=";
  };

  cargoHash = "sha256-FdXk6SzW0f3jkTfxMd8TMzfJGTRaZjG4qp56yHqDAuw=";
=======
    hash = "sha256-DdJa4ax/v86OgO+IAsiFA8/u6pEGcCw+N/3MLXzz8DM=";
  };

  cargoHash = "sha256-HkpFboXgHbJMYJFabJ58Syy1ag+InwqkeJAw8MxAr0A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    changelog = "https://github.com/hrkfdn/ncspot/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
  };
}
