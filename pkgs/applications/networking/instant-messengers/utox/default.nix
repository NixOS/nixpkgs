{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft }:


stdenv.mkDerivation rec {
  name = "utox-dev";

  src = fetchFromGitHub {
    owner = "notsecure";
    repo = "uTox";
    rev = "a840b459210694fdf02671567bf33845a11d4c83";
    sha256 = "0jr0xajkv5vkq8gxspnq09k4bzc98fr3hflnz8a3lrwajyhrnpvp";
  };

  buildInputs = [ pkgconfig libtoxcore dbus libvpx libX11 openal freetype
                  libv4l libXrender fontconfig libXext libXft ];

  doCheck = false;
  
  makeFlags = "DESTDIR=$(out)";

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ iElectric ];
    platforms = stdenv.lib.platforms.all;
  };
}
