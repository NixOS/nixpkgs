{ stdenv, fetchurl, pkgconfig, gtk, zathura_core, girara, libspectre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-ps-0.1.0";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "1669fd11e436636cdedb2cde206b562f4f9c666cea9773f6f2014e765fd62789";
  };

  buildInputs = [ pkgconfig libspectre gettext zathura_core gtk girara ];

  patches = [ ./gtkflags.patch ];

  makeFlags = "PREFIX=$(out) PLUGINDIR=$(out)/lib";

  meta = {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PS plugin";
    longDescription = ''
      The zathura-ps plugin adds PS support to zathura by using the
      libspectre library.
      '';
    license = "free";
    platforms = stdenv.lib.platforms.linux;
  };
}

