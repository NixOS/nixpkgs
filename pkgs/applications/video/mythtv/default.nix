{stdenv, fetchurl, which, qt3, x11, libXinerama, libXv, libXxf86vm, lame}:

assert qt3.mysqlSupport;

stdenv.mkDerivation {
  name = "mythtv-0.16";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/mythtv-0.16.tar.bz2;
    md5 = "0eba17cf64c96ea3ead23e7e15419cc0";
  };

  patches = [./settings.patch];

  buildInputs = [which qt3 x11 libXinerama libXv libXxf86vm lame];
  inherit qt3;
}
