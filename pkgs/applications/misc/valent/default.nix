{ lib
, stdenv
, fetchFromGitHub
, desktop-file-utils
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook4
, evolution-data-server-gtk4
, glib
, glib-networking
, gnutls
, gst_all_1
, json-glib
, libadwaita
, libpeas
, libportal-gtk4
, pulseaudio
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "valent";
<<<<<<< HEAD
  version = "unstable-2023-08-26";
=======
  version = "unstable-2023-05-01";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "valent";
<<<<<<< HEAD
    rev = "89d1e5a0312a0371bfcd9a95486805917c3729c0";
    fetchSubmodules = true;
    hash = "sha256-28l+SkjVQkOA/5f5nT5BbqIV2BrMLmSK/YtDGYl1xjQ=";
=======
    rev = "74f5d9349a60f0d9fcf88cda01713980a221d639";
    fetchSubmodules = true;
    sha256 = "sha256-wqdujEKizrDFXtsjSTWpFgDL7MH3tsLTc7yd3LFgIQU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    evolution-data-server-gtk4
    glib
    glib-networking
    gnutls
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    json-glib
    libadwaita
    libpeas
    libportal-gtk4
    pulseaudio
    sqlite
  ];

  mesonFlags = [
    "-Dplugin_bluez=true"
  ];

  meta = with lib; {
    description = "An implementation of the KDE Connect protocol, built on GNOME platform libraries";
    homepage = "https://github.com/andyholmes/valent/";
    changelog = "https://github.com/andyholmes/valent/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ gpl3Plus cc0 ];
    maintainers = with maintainers; [ federicoschonborn aleksana ];
    platforms = platforms.linux;
  };
}
