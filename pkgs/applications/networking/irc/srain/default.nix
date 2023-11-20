{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, gtk3
, libconfig
, libsoup
, libsecret
, openssl
, gettext
, glib
, glib-networking
, appstream-glib
, dbus-glib
, python3Packages
, meson
, ninja
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "srain";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "SrainApp";
    repo = "srain";
    rev = version;
    sha256 = "sha256-PiLjlsYmgxXpvcqDkwS/6WmTEimMH8+OndUG2Hehdm0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    appstream-glib
    wrapGAppsHook
    python3Packages.sphinx
  ];

  buildInputs = [
    gtk3
    glib
    glib-networking
    dbus-glib
    libconfig
    libsoup
    libsecret
    openssl
  ];

  meta = with lib; {
    description = "Modern IRC client written in GTK";
    homepage = "https://srain.silverrainz.me";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
