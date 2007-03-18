{ stdenv, fetchurl, libixp, x11, gawk}:

stdenv.mkDerivation {
  name = "wmii-snap20070304";
  description = "a really nice window manager which can be entirely driven by keyboard";
  homepage = "http://www.suckless.org/wiki/wmii/";
  builder = ./builder.sh;
  src = fetchurl {
    url =  http://www.suckless.org/snaps/wmii-snap20070304.tgz;
    sha256 = "06dd2e58c5cbb4adb9a8ba9cb8f19625a15df99b8ab7adec7ddc5844260e6a05";
  };
  buildInputs = [ libixp ];
  propagatedBuildInputs = [ x11 ];
  inherit gawk;
}
