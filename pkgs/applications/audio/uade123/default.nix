{ stdenv, fetchurl, which, libao, pkgconfig }:

let
  version = "2.13";
in stdenv.mkDerivation rec {
  name = "uade123-${version}";
  src = fetchurl {
    url = "http://zakalwe.fi/uade/uade2/uade-${version}.tar.bz2";
    sha256 = "04nn5li7xy4g5ysyjjngmv5d3ibxppkbb86m10vrvadzxdd4w69v";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ which libao ];

  meta = with stdenv.lib; {
    description = "Plays old Amiga tunes through UAE emulation and cloned m68k-assembler Eagleplayer API";
    homepage = http://zakalwe.fi/uade/;
    license = licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.gnidorah ];
    platforms = stdenv.lib.platforms.unix;
  };
}
