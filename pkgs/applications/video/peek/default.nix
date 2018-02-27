{ stdenv, fetchFromGitHub, cmake, gettext, libxml2, pkgconfig, txt2man, vala, wrapGAppsHook
, gsettings-desktop-schemas, gtk3, keybinder3
}:

stdenv.mkDerivation rec {
  name = "peek-${version}";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "phw";
    repo = "peek";
    rev = version;
    sha256 = "1ihmq914g2h5iw86bigkkblzqimr50yq6z883lzq656xkcayd8gh";
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
