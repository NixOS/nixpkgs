{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, vala, gettext, python3
, appstream-glib, desktop-file-utils, wrapGAppsHook, curl, gnome3, gst_all_1
, json-glib, libnotify, libsecret, sqlite, gumbo, glib, gtk3, libgee, libpeas
, libsoup, librest, webkitgtk, gsettings-desktop-schemas, gdk_pixbuf, libxml2
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "feedreader";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "jangernert";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qm7scrz8xm68zizcfn13ll4ksdd004fahki7gbwqagsr1fg62y8";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig vala gettext appstream-glib desktop-file-utils
    libxml2 python3 wrapGAppsHook
  ];

  buildInputs = [
    curl glib json-glib libnotify libsecret sqlite gumbo gtk3
    libgee libpeas libsoup librest webkitgtk gsettings-desktop-schemas
    gdk_pixbuf gnome3.gnome-online-accounts hicolor-icon-theme
  ] ++ (with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good
  ]);

  postPatch = ''
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A modern desktop application designed to complement existing web-based RSS accounts";
    homepage = https://jangernert.github.io/FeedReader/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ edwtjo worldofpeace ];
    platforms = platforms.linux;
  };
}
