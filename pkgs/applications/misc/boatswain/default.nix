{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gtk4
, libgee
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, libpeas
, libportal-gtk4
, gusb
, hidapi
, json-glib
, libsecret
, libsoup_3
}:

stdenv.mkDerivation rec {
  pname = "boatswain";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "boatswain";
    rev = version;
    hash = "sha256-Q16ooTaCgwbwEqa0iRzAoaS5OHCSi6dXaiVgC3uc/zc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgee
    libpeas
    libportal-gtk4
    gusb
    hidapi
    json-glib
    libsecret
    libsoup_3
  ];

  meta = with lib; {
    description = "Control Elgato Stream Deck devices.";
    homepage = "https://gitlab.gnome.org/World/boatswain";
    mainProgram = "boatswain";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0xMRTT ];
    broken = stdenv.isDarwin;
  };
}
