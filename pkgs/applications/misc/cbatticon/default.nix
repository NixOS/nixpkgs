{ stdenv, fetchFromGitHub, pkgconfig, gettext, glib, gtk3, libnotify }:

stdenv.mkDerivation rec {

  name = "cbatticon-${version}";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "valr";
    repo = "cbatticon";
    rev = version;
    sha256 = "0rm1rpq81cxjwd4f11c3ivg5hwsd08qm47vdn16yr1cmm2cw4r2d";
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
