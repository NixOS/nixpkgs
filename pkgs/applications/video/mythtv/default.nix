{stdenv, fetchurl, which, qt3, x11, libXinerama, libXv, libXxf86vm, lame}:

assert qt3.mysqlSupport;

stdenv.mkDerivation {
  name = "mythtv-0.17";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.mythtv.org/mc/mythtv-0.17.tar.bz2;
    md5 = "c996dc690d36e946396fc5cd4b715e3b";
  };

  patches = [./settings.patch];

  buildInputs = [which qt3 x11 libXinerama libXv libXxf86vm lame];
  inherit qt3;
}
