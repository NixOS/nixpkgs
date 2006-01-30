{stdenv, fetchurl, which, qt3, x11, libXinerama, libXv, libXxf86vm, lame}:

assert qt3.mysqlSupport;

stdenv.mkDerivation {
  name = "mythtv-0.18.1";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mythtv-0.18.1.tar.bz2;
    md5 = "e6cabf88feeaf6ae8f830d3fdf7b113d";
  };

  patches = [./settings.patch];
  configureFlags = "--disable-joystick-menu";

  buildInputs = [which qt3 x11 libXinerama libXv libXxf86vm lame];
  inherit qt3;
}
