{ stdenv, fetchurl , glib, pkgconfig, libogg, libvorbis, libmad }:

stdenv.mkDerivation rec {
  name = "streamripper-${version}";
  version = "1.64.6";

  src = fetchurl {
    url = "mirror://sourceforge/streamripper/${name}.tar.gz";
    sha256 = "0hnyv3206r0rfprn3k7k6a0j959kagsfyrmyjm3gsf3vkhp5zmy1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libogg libvorbis libmad ];

  meta = with stdenv.lib; {
    homepage = http://streamripper.sourceforge.net/;
    description = "Application that lets you record streaming mp3 to your hard drive";
    license = licenses.gpl2;
    maintainers = with maintainers; [ the-kenny ];
  };
}
