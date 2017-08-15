{ stdenv, fetchFromGitHub, pkgconfig, gettext, glib, gtk3, libnotify }:

stdenv.mkDerivation rec {

  name = "cbatticon-${version}";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "valr";
    repo = "cbatticon";
    rev = version;
    sha256 = "0gphijkjmg5q349ffhnx12dppg6hajkr90n0x5b6s9cad5b4q0kq";
  };

  makeFlags = "PREFIX=$(out)";

  nativeBuildInputs = [ pkgconfig gettext ];

  buildInputs =  [ glib gtk3 libnotify ];

  meta = with stdenv.lib; {
    description = "Lightweight and fast battery icon that sits in the system tray";
    homepage = https://github.com/valr/cbatticon;
    license = licenses.gpl2;
    maintainers = [ maintainers.domenkozar ];
    platforms = platforms.linux;
  };
}
