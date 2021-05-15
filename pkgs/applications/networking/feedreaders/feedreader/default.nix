{ lib, stdenv, fetchFromGitHub, nix-update-script, meson, ninja, pkg-config, vala, gettext, python3
, appstream-glib, desktop-file-utils, wrapGAppsHook, gnome-online-accounts
, gtk3, libgee, libpeas, librest, webkitgtk, gsettings-desktop-schemas
, curl, glib, gnome, gst_all_1, json-glib, libnotify, libsecret, sqlite, gumbo, libxml2
}:

stdenv.mkDerivation rec {
  pname = "feedreader";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "jangernert";
    repo = pname;
    rev = "v${version}";
    sha256 = "1agy1nkpkdsy2kbrrc8nrwphj5n86rikjjvwkr8klbf88mzl6civ";
  };

  nativeBuildInputs = [
    meson ninja pkg-config vala gettext appstream-glib desktop-file-utils
    libxml2 python3 wrapGAppsHook
  ];

  buildInputs = [
    curl glib json-glib libnotify libsecret sqlite gumbo gtk3
    libgee libpeas gnome.libsoup librest webkitgtk gsettings-desktop-schemas
    gnome-online-accounts
  ] ++ (with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good
  ]);

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A modern desktop application designed to complement existing web-based RSS accounts";
    homepage = "https://jangernert.github.io/FeedReader/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
