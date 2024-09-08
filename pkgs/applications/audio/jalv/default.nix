{ lib, stdenv, fetchurl, meson, ninja, pkg-config, wrapGAppsHook3
, gtk2, gtk3, libjack2, lilv, lv2, serd, sord , sratom, suil
}:

stdenv.mkDerivation  rec {
  pname = "jalv";
  version = "1.6.8";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.xz";
    hash = "sha256-7a53sSgOpE1MCytzJobe/TcP3iXtHaKJiW2fU7b8FeE=";
  };

  nativeBuildInputs = [ meson ninja pkg-config wrapGAppsHook3 ];
  buildInputs = [ gtk2 gtk3 libjack2 lilv lv2 serd sord sratom suil ];

  mesonFlags = [
    "-Dgtk2=enabled"
    "-Dgtk3=enabled"
    "-Dqt5=disabled"
    "-Dportaudio=disabled" # portaudio and jack are mutually exclusive
  ];

  meta = with lib; {
    description = "Simple but fully featured LV2 host for Jack";
    homepage = "http://drobilla.net/software/jalv";
    license = licenses.isc;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
