{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, vala, gettext, python3
, appstream-glib, desktop-file-utils, wrapGAppsHook, gnome-online-accounts
, gtk3, libgee, libpeas, librest, webkitgtk, gsettings-desktop-schemas, hicolor-icon-theme
, curl, glib, gnome3, gst_all_1, json-glib, libnotify, libsecret, sqlite, gumbo, libxml2
}:

stdenv.mkDerivation rec {
  pname = "feedreader";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "jangernert";
    repo = pname;
    rev = "v${version}";
    sha256 = "154lzvd8acs4dyc91nlabpr284yrij8jkhgm0h18hp3cy0a11rv8";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig vala gettext appstream-glib desktop-file-utils
    libxml2 python3 wrapGAppsHook
  ];

  buildInputs = [
    curl glib json-glib libnotify libsecret sqlite gumbo gtk3
    libgee libpeas gnome3.libsoup librest webkitgtk gsettings-desktop-schemas
    gnome-online-accounts
    hicolor-icon-theme # for setup hook
  ] ++ (with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good
  ]);

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A modern desktop application designed to complement existing web-based RSS accounts";
    homepage = https://jangernert.github.io/FeedReader/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ edwtjo worldofpeace ];
    platforms = platforms.linux;
  };
}
