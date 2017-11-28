{ stdenv, fetchFromGitHub, cmake, pkgconfig, gettext, vala, gtk3, wrapGAppsHook
, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {
  name = "peek-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "phw";
    repo = "peek";
    rev = version;
    sha256 = "04sc6gfrqvnx288rmgsywpjx9l6jcfn2qdbwjcbdvx4wl3gna0qm";
  };

  nativeBuildInputs = [ cmake pkgconfig gettext wrapGAppsHook ];
  buildInputs = [ vala gtk3 gsettings_desktop_schemas ];

  meta = with stdenv.lib; {
    homepage    = https://github.com/phw/peek;
    description = "Simple animated GIF screen recorder with an easy to use interface";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ puffnfresh ];
    platforms   = with platforms; unix;
  };
}
