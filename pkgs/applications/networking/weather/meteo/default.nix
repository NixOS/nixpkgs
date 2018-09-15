{ stdenv, fetchFromGitLab, vala, python3, pkgconfig, meson, ninja, granite, gtk3
, gnome3, json-glib, libsoup, clutter, clutter-gtk, libchamplain, webkitgtk
, libappindicator, desktop-file-utils, appstream, gobjectIntrospection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "meteo";
  version = "0.8.5";

  name = "${pname}-${version}";

  src = fetchFromGitLab {
    owner = "bitseater";
    repo = pname;
    rev = version;
    sha256 = "1mc2djhkg0nzcjmy87l1wqwni48vgpqh8s1flr90pipk12a1mh7n";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter
    clutter-gtk
    gnome3.geocode-glib
    gtk3
    json-glib
    libappindicator
    libchamplain
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
