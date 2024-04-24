{ lib
, stdenv
, fetchFromGitLab
, pkg-config
, autoreconfHook
, wrapGAppsHook
, gtkmm3
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "gmetronome";
  version = "0.3.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "dqpb";
    repo = "gmetronome";
    rev = version;
    hash = "sha256-ilFO1HwleWIQ51Bkzck1sm1Yu3ugqkvZrpxPOYzXydM=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    wrapGAppsHook
  ];

  buildInputs = [
    gtkmm3
    libpulseaudio
  ];

  meta = with lib; {
    description = "A free software metronome and tempo measurement tool";
    homepage = "https://gitlab.gnome.org/dqpb/gmetronome";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aleksana ];
    mainProgram = "gmetronome";
    broken = stdenv.isDarwin;
  };
}
