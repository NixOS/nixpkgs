{ stdenv, fetchurl
, libX11, libXext, libXaw
, pkgconfig, imlib2, libast }:

stdenv.mkDerivation rec {
  name = "eterm-${version}";
  version = "0.9.6";
  srcName = "Eterm-${version}";

  src = fetchurl {
    url = "http://www.eterm.org/download/${srcName}.tar.gz";
    sha256 = "0g71szjklkiczxwzbjjfm59y6v9w4hp8mg7cy99z1g7qcjm0gfbj";
  };

  buildInputs = [ libX11 libXext libXaw pkgconfig imlib2 ];
  propagatedBuildInputs = [ libast ];

  meta = with stdenv.lib; {
    description = "Terminal emulator";
    homepage = http://www.eterm.org;
    license = licenses.bsd2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
