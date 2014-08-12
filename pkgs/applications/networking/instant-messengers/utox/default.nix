{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft }:


stdenv.mkDerivation rec {
  name = "utox-dev";

  src = fetchFromGitHub {
    owner = "notsecure";
    repo = "uTox";
    rev = "d70f9bfb4ff8a156ec35803da6226b0ac8c47961";
    sha256 = "10cvsg0phv0jsrdl3zkk339c4bzn3xc82q1x90h6gcnrbg4vzmp0";
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
