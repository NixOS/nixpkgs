{ stdenv
, fetchFromGitHub
, cmake
, ninja
, pkgconfig
, pantheon
, gtk3
, glib
, libxml2
, webkitgtk
, clutter-gtk
, clutter-gst
, libunity
, libnotify
, sqlite
, gst_all_1
, libsoup
, json-glib
, libgee
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "vocal";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "needle-and-thread";
    repo = pname;
    rev = version;
    sha256 = "09g9692rckdwh1i5krqgfwdx4p67b1q5834cnxahxzpq4p08rf5w";
  };

  nativeBuildInputs = [
    cmake
    libxml2
    ninja
    pantheon.vala
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    clutter-gst
    clutter-gtk
    glib
    gst-plugins-base
    gst-plugins-good
    gstreamer
    gtk3
    json-glib
    libgee
    libnotify
    libunity
    pantheon.elementary-icon-theme
    pantheon.granite
    sqlite
    webkitgtk
  ];

  meta = with stdenv.lib; {
    description = "The podcast client for the modern free desktop";
    longDescription = ''
      Vocal is a powerful, fast, and intuitive application that helps users find new podcasts, manage their libraries, and enjoy the best that indepedent audio and video publishing has to offer. Vocal features full support for both episode downloading and streaming, native system integration, iTunes store search and top 100 charts (with international results support), iTunes link parsing, OPML importing and exporting, and so much more. Plus, it has great smart features like automatically keeping your library clean from old files, and the ability to set custom skip intervals.
    '';
    homepage = https://github.com/needle-and-thread/vocal;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
