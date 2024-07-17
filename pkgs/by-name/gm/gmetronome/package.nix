{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  autoreconfHook,
  wrapGAppsHook3,
  gtkmm3,
  libpulseaudio,
}:

stdenv.mkDerivation rec {
  pname = "gmetronome";
  version = "0.3.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "dqpb";
    repo = "gmetronome";
    rev = version;
    hash = "sha256-fjtdM2/LMZx0dFt78Ih4BG5+NZoocPknh5INA+2e5qk=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    libpulseaudio
  ];

  meta = with lib; {
    description = "Free software metronome and tempo measurement tool";
    homepage = "https://gitlab.gnome.org/dqpb/gmetronome";
    changelog = "https://gitlab.gnome.org/dqpb/gmetronome/-/blob/${src.rev}/NEWS";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aleksana ];
    mainProgram = "gmetronome";
    broken = stdenv.isDarwin;
  };
}
