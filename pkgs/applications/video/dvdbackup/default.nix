{ stdenv, fetchurl, libdvdread, libdvdcss, dvdauthor }:

stdenv.mkDerivation rec {
  version = "0.4.2";
  name = "dvdbackup-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/dvdbackup/${name}.tar.xz";
    sha256 = "1rl3h7waqja8blmbpmwy01q9fgr5r0c32b8dy3pbf59bp3xmd37g";
  };

  buildInputs = [ libdvdread libdvdcss dvdauthor ];

  meta = {
    description = "A tool to rip video DVDs from the command line";
    homepage = http://dvdbackup.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.bradediger ];
  };
}
