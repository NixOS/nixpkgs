{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft }:


stdenv.mkDerivation rec {
  name = "utox-dev-20141130";

  src = fetchFromGitHub {
    owner = "notsecure";
    repo = "uTox";
    rev = "38b0a2014f";
    sha256 = "00g9fsp83yjq6dfim3hfpag0ny9w5kydghycfj3ic8qaljp47y8a";
  };

  buildInputs = [ pkgconfig libtoxcore dbus libvpx libX11 openal freetype
                  libv4l libXrender fontconfig libXext libXft ];

  doCheck = false;
  
  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iElectric jgeerds ];
    platforms = platforms.all;
  };
}
