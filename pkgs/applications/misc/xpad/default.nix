{ stdenv, fetchurl
, autoreconfHook, pkgconfig, wrapGAppsHook
, glib, intltool, gtk3, gtksourceview }:

stdenv.mkDerivation rec {
  name = "xpad-${version}";
  version = "5.0.0";

  src = fetchurl {
    url = "https://launchpad.net/xpad/trunk/${version}/+download/xpad-${version}.tar.bz2";
    sha256 = "02yikxg6z9bwla09ka001ppjlpbv5kbza3za9asazm5aiz376mkb";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig wrapGAppsHook ];

  buildInputs = [ glib intltool gtk3 gtksourceview ];

  autoreconfPhase = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "A sticky note application for jotting down things to remember";
    homepage = https://launchpad.net/xpad;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michalrus ];
  };
}
