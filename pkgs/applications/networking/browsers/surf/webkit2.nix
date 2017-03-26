{ stdenv, fetchzip
, pkgconfig, wrapGAppsHook
, glib, glib_networking, gsettings_desktop_schemas, gtk2, libsoup, webkitgtk
, patches ? null
}:

let
  # http://git.suckless.org/surf/log/?h=surf-webkit2
  rev = "7e02344a615a61246ccce1c7f770e88fbd57756e";
  sha256 = "11f93fbjhl7nfgwkcc45lcm3x1wk5h87ap8fbw9w855021i57pp6";
  date = "2017-03-22";
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
