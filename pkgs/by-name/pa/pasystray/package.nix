{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  wrapGAppsHook3,
  adwaita-icon-theme,
  avahi,
  gtk3,
  libayatana-appindicator,
  libnotify,
  libpulseaudio,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation {
  pname = "pasystray";
  version = "0.8.2-unstable-2025-10-04";

  src = fetchFromGitHub {
    owner = "christophgysin";
    repo = "pasystray";
    rev = "5a199dc6958bcaac07a8031eb48b9fad8730bf71";
    sha256 = "sha256-1vP1ZNvq7raz9te5WK+RPTP09BzF/jAFoeRjsvYXmZo=";
  };

  patches = [
    # Require X11 backend
    # https://github.com/christophgysin/pasystray/issues/90#issuecomment-361881076
    ./require-x11-backend.patch
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    adwaita-icon-theme
    avahi
    gtk3
    libayatana-appindicator
    libnotify
    libpulseaudio
    gsettings-desktop-schemas
  ];

  meta = {
    description = "PulseAudio system tray";
    homepage = "https://github.com/christophgysin/pasystray";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      exlevan
      kamilchm
    ];
    platforms = lib.platforms.linux;
    mainProgram = "pasystray";
  };
}
