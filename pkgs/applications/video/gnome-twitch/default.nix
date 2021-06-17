{ stdenv, fetchFromGitHub
, pkgconfig, meson, cmake, ninja, wrapGAppsHook
, libpeas, gtk3, libsoup, json-glib, webkitgtk, glib, glib-networking
, cairo, clutter-gtk, clutter-gst, epoxy, gstreamer, mpv
, python3, desktop-file-utils
, substituteAll
}:

stdenv.mkDerivation rec {
  pname = "gnome-twitch-unstable";
  version = "2019-05-20";

  src = fetchFromGitHub {
    owner = "vinszent";
    repo = "gnome-twitch";
    rev = "8e774a04fdd15fa4c9990918bf89295a232d1715";
    sha256 = "0pvxfwbv4fms2d0sp43jw83kp1i6gq03kg6gwy8b1fhp473gxrfj";
  };

  nativeBuildInputs = [ pkgconfig meson cmake ninja wrapGAppsHook python3 ];
  buildInputs = [
    libpeas gtk3 libsoup json-glib webkitgtk glib glib-networking
    cairo clutter-gtk clutter-gst epoxy gstreamer mpv
  ];
  mesonFlags = [
    "-Dbuild-player-backends=gstreamer-cairo,gstreamer-opengl,gstreamer-clutter,mpv-opengl"
  ];
  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    substituteInPlace meson_post_install.py \
      --replace "update-desktop-database" \
                "${desktop-file-utils}/bin/update-desktop-database" \
  '';

  meta = with stdenv.lib; {
    description = "Gnome Twitch: enjoy Twitch on your GNU/Linux desktop";
    homepage = "https://gnome-twitch.vinszent.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
