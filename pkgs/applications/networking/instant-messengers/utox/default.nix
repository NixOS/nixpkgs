{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft }:


stdenv.mkDerivation rec {
  name = "utox-dev-20140918";

  src = fetchFromGitHub {
    owner = "notsecure";
    repo = "uTox";
    rev = "26d4308ad0";
    sha256 = "0vc46dpg3hd7pfx8zny0wf546f1wfag7d8wj5rg47dg3wzwghz8p";
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
