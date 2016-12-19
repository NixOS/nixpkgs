{ stdenv, fetchurl, intltool, pkgconfig, glib, libnotify, gtk3, libgee
, keybinder3, json_glib, zeitgeist, vala_0_23, hicolor_icon_theme
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "synapse-0.2.99.1";

  src = fetchurl {
    url = "https://launchpad.net/synapse-project/0.3/0.2.99.1/+download/${name}.tar.xz";
    sha256 = "846d8a5130580bb47c754bb7f20dc76311e589c00a18b02370a5d78b52409220";
  };

  buildInputs = [
    intltool pkgconfig glib libnotify gtk3 libgee keybinder3 json_glib zeitgeist 
    vala_0_23 hicolor_icon_theme
  ];

  meta = { 
      longDescription = ''
        Semantic launcher written in Vala that you can use to start applications 
        as well as find and access relevant documents and files by making use of 
        the Zeitgeist engine
      '';
      description = ''
        Semantic launcher to start applications and find relevant files
      '';
      homepage = https://launchpad.net/synapse-project;
      license = stdenv.lib.licenses.gpl3;
      maintainers = with stdenv.lib.maintainers; mahe;
      platforms = with stdenv.lib.platforms; all;
  };
}
