{ stdenv, fetchFromGitHub, cmake, gettext, libxml2, pkgconfig, txt2man, vala, wrapGAppsHook
, gsettings-desktop-schemas, gtk3, keybinder3
}:

stdenv.mkDerivation rec {
  name = "peek-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "phw";
    repo = "peek";
    rev = version;
    sha256 = "04sc6gfrqvnx288rmgsywpjx9l6jcfn2qdbwjcbdvx4wl3gna0qm";
  };

  nativeBuildInputs = [ cmake gettext pkgconfig libxml2.bin txt2man vala wrapGAppsHook ];

  buildInputs = [ gsettings-desktop-schemas gtk3 keybinder3 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = https://github.com/phw/peek;
    description = "Simple animated GIF screen recorder with an easy to use interface";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ puffnfresh ];
    platforms   = platforms.linux;
  };
}
