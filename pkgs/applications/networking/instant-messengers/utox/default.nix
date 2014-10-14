{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft }:


stdenv.mkDerivation rec {
  name = "utox-dev-20140921";

  src = fetchFromGitHub {
    owner = "notsecure";
    repo = "uTox";
    rev = "c0afc95cf3";
    sha256 = "0a6i0c9crj6b27alm8q0fcfj8q425khg5305sp57r7pj505l4d1f";
  };

  buildInputs = [ pkgconfig libtoxcore dbus libvpx libX11 openal freetype
                  libv4l libXrender fontconfig libXext libXft ];

  doCheck = false;
  
  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ iElectric ];
    platforms = stdenv.lib.platforms.all;
  };
}
