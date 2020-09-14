{ stdenv
, fetchFromGitHub
, meson
, ninja
, gtk3
, pkgconfig
, python3
, desktop-file-utils
, vala
, wrapGAppsHook
, appstream
, clutter-gtk
, cmake
, gst_all_1
, json-glib
, libgee
, libsoup
, pantheon
, sqlite
, taglib
}:

stdenv.mkDerivation rec {
  pname = "melody";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "artemanufrij";
    repo = "playmymusic";
    rev = "bba5fe74134ad7533c41044d8ce41f1a8f69b3b0";
    sha256 = "0kjzy87bvgp5zpk35n21758ka8wbl8g5xbfiw4aljpxw4sb9isql";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    appstream
    clutter-gtk
    cmake
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk3
    json-glib
    libgee
    libsoup
    pantheon.elementary-icon-theme
    pantheon.granite
    sqlite
    taglib
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A music player for listening to local music files, online radio and Audio CD's - Designed for elementary OS";
    homepage = "https://anufrij.org/melody";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hotlineguy ];
  };
}
