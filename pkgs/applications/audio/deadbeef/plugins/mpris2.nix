{ stdenv, fetchurl, pkgconfig, deadbeef, glib }:

stdenv.mkDerivation rec {
  name = "deadbeef-mpris2-plugin-${version}";
  version = "1.10";

  src = fetchurl {
    url = "https://github.com/Serranya/deadbeef-mpris2-plugin/releases/download/v${version}/${name}.tar.xz";
    sha256 = "083fbvi06y85khr8hdm4rl5alxdanjbbyphizyr4hi93d7a0jg75";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ deadbeef glib ];

  meta = with stdenv.lib; {
    description = "MPRISv2 plugin for the DeaDBeeF music player";
    homepage = https://github.com/Serranya/deadbeef-mpris2-plugin/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.abbradar ];
  };
}
