{ stdenv, fetchFromGitLab, vala, python3, pkgconfig, meson, ninja, gtk3
, json-glib, libsoup, webkitgtk, geocode-glib
, libappindicator, desktop-file-utils, appstream, wrapGAppsHook
, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "meteo";
  version = "0.9.7";

  src = fetchFromGitLab {
    owner = "bitseater";
    repo = pname;
    rev = version;
    sha256 = "014x3mg2dc58h1qwy2nrz3a5mzdnbzish8zgn3x6lj6szfz5c72n";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    geocode-glib
    gtk3
    hicolor-icon-theme
    json-glib
    libappindicator
    libsoup
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Know the forecast of the next hours & days";
    homepage    = https://gitlab.com/bitseater/meteo;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.linux;
  };
}
