{stdenv, fetchurl, which, qt3, x11, libXinerama, libXv, libXxf86vm, lame}:

stdenv.mkDerivation {
  name = "mythtv-0.16";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.mythtv.org/mc/mythtv-0.16.tar.bz2;
    md5 = "0eba17cf64c96ea3ead23e7e15419cc0";
  };

  buildInputs = [which qt3 x11 libXinerama libXv libXxf86vm lame];
  inherit qt3;
}
