{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  libconfig,
  libsoup_3,
  libsecret,
  libayatana-appindicator,
  openssl,
  gettext,
  glib,
  glib-networking,
  appstream-glib,
  dbus-glib,
  python3Packages,
  meson,
  ninja,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "srain";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "SrainApp";
    repo = "srain";
    rev = version;
    hash = "sha256-F7TFCPTAU856403QNUUyf+10s/Yr4xDN/CarJNcUv4A=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    appstream-glib
    wrapGAppsHook3
    python3Packages.sphinx
  ];

  buildInputs = [
    gtk3
    glib
    glib-networking
    dbus-glib
    libconfig
    libsoup_3
    libsecret
    libayatana-appindicator
    openssl
  ];

  meta = with lib; {
    description = "Modern IRC client written in GTK";
    mainProgram = "srain";
    homepage = "https://srain.silverrainz.me";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wineee ];
  };
}
