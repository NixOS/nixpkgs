{ stdenv, lib, fetchurl, pkgconfig, gtk, zathura_core, girara, libspectre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-ps-0.2.3";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "18wsfy8pqficdgj8wy2aws7j4fy8z78157rhqk17mj5f295zgvm9";
  };

  buildInputs = [ pkgconfig libspectre gettext zathura_core gtk girara ];

  patches = [ ./gtkflags.patch ];

  makeFlags = "PREFIX=$(out) PLUGINDIR=$(out)/lib";

  meta = with lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PS plugin";
    longDescription = ''
      The zathura-ps plugin adds PS support to zathura by using the
      libspectre library.
      '';
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan garbas ];
  };
}

