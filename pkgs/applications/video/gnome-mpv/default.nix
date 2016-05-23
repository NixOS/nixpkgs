{ stdenv, fetchurl
, intltool, pkgconfig, wrapGAppsHook
, appstream-glib, epoxy, glib, gtk3, mpv
}:

stdenv.mkDerivation rec {
  name = "gnome-mpv-${version}";
  version = "0.9";

  src = fetchurl {
    sha256 = "06pgxl6f3kkgxv8nlmyl7gy3pg55sqf8vgr8m6426mlpm4p3qdn0";
    url = "https://github.com/gnome-mpv/gnome-mpv/releases/download/v${version}/${name}.tar.xz";
  };

  nativeBuildInputs = [ intltool pkgconfig wrapGAppsHook ];
  buildInputs = [ appstream-glib epoxy glib.dev gtk3 mpv ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Simple GTK+ frontend for the mpv video player";
    longDescription = ''
      GNOME MPV interacts with mpv via the client API exported by libmpv,
      allowing access to mpv's powerful playback capabilities through an
      easy-to-use user interface.
    '';
    homepage = https://github.com/gnome-mpv/gnome-mpv;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
