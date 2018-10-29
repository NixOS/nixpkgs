{ stdenv, fetchFromGitHub, cmake, ninja, pkgconfig, vala, gtk3, libxml2, granite, webkitgtk, clutter-gtk
, clutter-gst, libunity, libnotify, sqlite, gst_all_1, libsoup, json-glib, gnome3, gobjectIntrospection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "vocal";
  version = "2.2.0";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "needle-and-thread";
    repo = pname;
    rev = version;
    sha256 = "09cm4azyaa9fmfymygf25gf0klpm5p04k6bc1i90jhw0f1im8sgl";
  };

  nativeBuildInputs = [
    cmake
    gobjectIntrospection
    libxml2
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    clutter-gst
    clutter-gtk
    gnome3.libgee
    granite
    gst-plugins-base
    gst-plugins-good
    gstreamer
    json-glib
    libnotify
    libunity
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
