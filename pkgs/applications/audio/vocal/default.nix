{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, cmake
, ninja
, vala
, pkg-config
, pantheon
, gtk3
, glib
, glib-networking
, libxml2
, webkitgtk
, clutter-gtk
, clutter-gst
, libunity
, libnotify
, sqlite
, gst_all_1
, json-glib
, libgee
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "vocal";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "needle-and-thread";
    repo = pname;
    rev = version;
    sha256 = "1c4n89rdl9r13kmmh2qymmy9sa6shjwai7df48k2kfn0pnzq5mad";
  };

  nativeBuildInputs = [
    cmake
    libxml2
    ninja
    vala
    pkg-config
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
    glib-networking
  ];

  patches = [
    # granite 6.0.0 removed about dialogs
    # see: https://github.com/needle-and-thread/vocal/issues/483
    (fetchpatch {
      name = "remove-about.patch";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/03543ffdb6cd52ce1a8293f3303225b3afac2431/trunk/remove-about.patch";
      sha256 = "sha256-yGD7BYOTmqs4h+Odh/mB3fI1HM7GDO6F+QaHpRUD5p4=";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "The podcast client for the modern free desktop";
    longDescription = ''
      Vocal is a powerful, fast, and intuitive application that helps users find new podcasts, manage their libraries, and enjoy the best that indepedent audio and video publishing has to offer. Vocal features full support for both episode downloading and streaming, native system integration, iTunes store search and top 100 charts (with international results support), iTunes link parsing, OPML importing and exporting, and so much more. Plus, it has great smart features like automatically keeping your library clean from old files, and the ability to set custom skip intervals.
    '';
    homepage = "https://github.com/needle-and-thread/vocal";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.needleandthread.vocal";
  };
}
