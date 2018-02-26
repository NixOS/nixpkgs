{ stdenv, fetchurl, gettext, pkgconfig, glib, libnotify, gtk3, libgee
, keybinder3, json-glib, zeitgeist, vala_0_38, hicolor-icon-theme, gobjectIntrospection
}:

let
  version = "0.2.99.3";
in stdenv.mkDerivation rec {
  name = "synapse-${version}";

  src = fetchurl {
    url = "https://launchpad.net/synapse-project/0.3/${version}/+download/${name}.tar.xz";
    sha256 = "0rwd42164xqfi40r13yr29cx6zy3bckgxk00y53b376nl5yqacvy";
  };

  nativeBuildInputs = [
    pkgconfig gettext vala_0_38
    # For setup hook
    gobjectIntrospection
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
