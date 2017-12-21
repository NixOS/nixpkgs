{ stdenv, fetchurl, intltool, pkgconfig, glib, libnotify, gtk3, libgee
, keybinder3, json_glib, zeitgeist, vala_0_34, hicolor_icon_theme
}:

let
  version = "0.2.99.2";
in stdenv.mkDerivation rec {
  name = "synapse-${version}";

  src = fetchurl {
    url = "https://launchpad.net/synapse-project/0.3/${version}/+download/${name}.tar.xz";
    sha256 = "04cnsmwf9xa52dh7rpb4ia715c0ls8jg1p7llc9yf3lbg1m0bvzv";
  };

  nativeBuildInputs = [ pkgconfig intltool vala_0_34 ];
  buildInputs = [
    glib libnotify gtk3 libgee keybinder3 json_glib zeitgeist
    hicolor_icon_theme
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
