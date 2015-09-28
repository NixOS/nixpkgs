{ stdenv, fetchurl, pkgconfig, deadbeef, glib }:

stdenv.mkDerivation rec {
  version = "1.8";
  name = "deadbeef-mpris2-plugin-${version}";

  src = fetchurl {
    url = "https://github.com/Serranya/deadbeef-mpris2-plugin/releases/download/v${version}/${name}.tar.xz";
    sha256 = "1xg880zlxbqz7hs5g7xwc128l08j8c3isn45rdi138hi4fqbyjfi";
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
