{ stdenv, fetchFromGitHub, autoconf, automake, gtkdoc, libtool, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "osm-gps-map-${version}";

  src = fetchFromGitHub {
    owner = "nzjrs";
    repo = "osm-gps-map";
    rev = "${version}";
    sha256 = "0hx6s67cnf37b8z4kcm6dsmnyrp2qlhvr3zhk3g3lq8ra5wrmn1v";
  };

 nativeBuildInputs = [ autoreconfHook autoconf automake libtool gtkdoc];

  buildInputs = [ ];

  meta = with stdenv.lib; {
    description = "Gtk+ Widget for Displaying OpenStreetMap tiles";
    homepage = http://nzjrs.github.io/osm-gps-map;
    maintainers = [ maintainers.ikervagyok ];
  };
}
