{ stdenv, fetchurl, pkgconfig, gtk, zathura_core, girara, libspectre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-ps-0.2.0";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "717eda01213b162421b6b52f29d6b981edc302fddf351ccb2c093b6842751414";
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
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.garbas ];
  };
}

