{ stdenv, fetchurl
, pkgconfig, wrapGAppsHook
, glib, glib_networking, gsettings_desktop_schemas, gtk, libsoup, webkitgtk
, patches ? null
}:

stdenv.mkDerivation rec {
  name = "surf-${version}";
  version = "2.0";

  src = fetchurl {
    url = "http://dl.suckless.org/surf/surf-${version}.tar.gz";
    sha256 = "07cmajyafljigy10d21kkyvv5jf3hxkx06pz3rwwk3y3c9x4rvps";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ glib glib_networking gsettings_desktop_schemas gtk libsoup webkitgtk ];

  inherit patches;

  installFlags = [ "PREFIX=/" "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "A simple web browser based on WebKit/GTK+";
    longDescription = ''
      Surf is a simple web browser based on WebKit/GTK+. It is able to display
      websites and follow links. It supports the XEmbed protocol which makes it
      possible to embed it in another application. Furthermore, one can point
      surf to another URI by setting its XProperties.
    '';
    homepage = http://surf.suckless.org;
    license = licenses.mit;
    platforms = webkitgtk.meta.platforms;
    maintainers = with maintainers; [ joachifm ];
  };
}
