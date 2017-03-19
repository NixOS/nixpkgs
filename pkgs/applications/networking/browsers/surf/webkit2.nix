{ stdenv, fetchzip
, pkgconfig, wrapGAppsHook
, glib, glib_networking, gsettings_desktop_schemas, gtk2, libsoup, webkitgtk
, patches ? null
}:

let
  # http://git.suckless.org/surf/log/?h=surf-webkit2
  rev = "37e43501d80710533f3ec0bd61ee84916c8524a4";
  sha256 = "1q388rzm4irpaam4z8xycbyh5dgkjlar5jn1iw7zfls1pbpzr5br";
  date = "2017-03-06";
in

stdenv.mkDerivation rec {
  name = "surf-webkit2-${date}";

  src = fetchzip {
    url = "http://git.suckless.org/surf/snapshot/surf-${rev}.tar.gz";
    inherit sha256;
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ glib glib_networking gsettings_desktop_schemas gtk2 libsoup webkitgtk ];

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
    platforms = platforms.all;
    maintainers = with maintainers; [ joachifm ];
  };
}
