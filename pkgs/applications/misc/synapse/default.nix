{ stdenv, fetchurl, gettext, pkgconfig, glib, libnotify, gtk3, libgee
, keybinder3, json-glib, zeitgeist, vala_0_38, hicolor-icon-theme, gobject-introspection
}:

let
  version = "0.2.99.4";
in stdenv.mkDerivation rec {
  name = "synapse-${version}";

  src = fetchurl {
    url = "https://launchpad.net/synapse-project/0.3/${version}/+download/${name}.tar.xz";
    sha256 = "1g6x9knb4jy1d8zgssjhzkgac583137pibisy9whjs8mckaj4k1j";
  };

  nativeBuildInputs = [
    pkgconfig gettext vala_0_38
    # For setup hook
    gobject-introspection
  ];
  buildInputs = [
    glib libnotify gtk3 libgee keybinder3 json-glib zeitgeist
    hicolor-icon-theme
  ];

  meta = with stdenv.lib; {
    longDescription = ''
      Semantic launcher written in Vala that you can use to start applications
      as well as find and access relevant documents and files by making use of
      the Zeitgeist engine
    '';
    description = "Semantic launcher to start applications and find relevant files";
    homepage = https://launchpad.net/synapse-project;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mahe ];
    platforms = with platforms; all;
  };
}
