{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, vala, gettext, python3
, appstream-glib, desktop-file-utils, wrapGAppsHook, gnome-online-accounts, fetchpatch
, gtk3, libgee, libpeas, librest, webkitgtk, gsettings-desktop-schemas, pantheon
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
  ] ++ (with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good
  ]);

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
  '';

  patches = [
    # Fixes build with libsecret
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/jangernert/FeedReader/pull/943.patch";
      sha256 = "0anrwvcg6607dzvfrhy5qcnpxzflskb3iy3khdg191aw1h2mqhb5";
    })
  ];

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A modern desktop application designed to complement existing web-based RSS accounts";
    homepage = https://jangernert.github.io/FeedReader/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ edwtjo worldofpeace ];
    platforms = platforms.linux;
  };
}
