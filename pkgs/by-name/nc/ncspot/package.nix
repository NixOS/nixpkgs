{
  lib,
  stdenv,
  alsa-lib,
  apple-sdk_11,
  config,
  dbus,
  fetchFromGitHub,
  libpulseaudio,
  libxcb,
  ncspot,
  ncurses,
  nix-update-script,
  openssl,
  pkg-config,
  portaudio,
  python3,
  rustPlatform,
  testers,
  ueberzug,
  withALSA ? stdenv.hostPlatform.isLinux,
  withClipboard ? true,
  withCover ? false,
  withCrossterm ? true,
  withMPRIS ? stdenv.hostPlatform.isLinux,
  withNcurses ? false,
  withNotify ? true,
  withPancurses ? false,
  withPortAudio ? stdenv.hostPlatform.isDarwin,
  withPulseAudio ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  withRodio ? false,
  withShareSelection ? false,
  withTermion ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "ncspot";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "refs/tags/v${version}";
    hash = "sha256-h3Mp67AKuzzeO6l7jN6yrQAHpYSsaOp1Y+qJoamK82U=";
  };

  cargoHash = "sha256-uWnW4Ov5MoDh3xkmTsNSin9WI0SJAoDGa+n8IMNvo4Y=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optional withClipboard python3;

  buildInputs =
    [ ncurses ]
    ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11
    ++ lib.optional stdenv.hostPlatform.isLinux openssl
    ++ lib.optional (withALSA || withRodio) alsa-lib
    ++ lib.optional withClipboard libxcb
    ++ lib.optional withCover ueberzug
    ++ lib.optional (withMPRIS || withNotify) dbus
    ++ lib.optional withNcurses ncurses
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional withPulseAudio libpulseaudio;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-DNCURSES_UNCTRL_H_incl";

  buildNoDefaultFeatures = true;

  buildFeatures =
    lib.optional withALSA "alsa_backend"
    ++ lib.optional withClipboard "share_clipboard"
    ++ lib.optional withCover "cover"
    ++ lib.optional withCrossterm "crossterm_backend"
    ++ lib.optional withMPRIS "mpris"
    ++ lib.optional withNcurses "ncurses_backend"
    ++ lib.optional withNotify "notify"
    ++ lib.optional withPancurses "pancurses_backend"
    ++ lib.optional withPortAudio "portaudio_backend"
    ++ lib.optional withPulseAudio "pulseaudio_backend"
    ++ lib.optional withRodio "rodio_backend"
    ++ lib.optional withShareSelection "share_selection"
    ++ lib.optional withTermion "termion_backend";

  postInstall = ''
    install -D --mode=444 $src/misc/ncspot.desktop $out/share/applications/ncspot.desktop
    install -D --mode=444 $src/images/logo.svg $out/share/icons/hicolor/scalable/apps/ncspot.svg
  '';

  passthru = {
    tests.version = testers.testVersion { package = ncspot; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes";
    homepage = "https://github.com/hrkfdn/ncspot";
    changelog = "https://github.com/hrkfdn/ncspot/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      liff
      getchoo
    ];
    mainProgram = "ncspot";
  };
}
