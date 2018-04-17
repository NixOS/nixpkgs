{ stdenv, fetchFromGitHub, cmake, gettext, libxml2, pkgconfig, txt2man, vala, wrapGAppsHook
, gsettings-desktop-schemas, gtk3, keybinder3
}:

stdenv.mkDerivation rec {
  name = "peek-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "phw";
    repo = "peek";
    rev = version;
    sha256 = "0yizf55rzkm88bfjzwr8yyhm33yqp1mbih2ifwhvnjd1911db0x9";
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
