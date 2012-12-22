{ stdenv, fetchurl, pkgconfig, zathura_core, girara, poppler, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-pdf-poppler-0.2.1";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "1c162ea887e52f48d6dc80f8427a773768f2df2e37242dab7efddeb3d2e361cd";
  };

  buildInputs = [ pkgconfig poppler gettext zathura_core girara ];

  makeFlags = "PREFIX=$(out) PLUGINDIR=$(out)/lib";

  meta = {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PDF plugin";
    longDescription = ''
      The zathura-pdf-poppler plugin adds PDF support to zathura by 
      using the poppler rendering engine.
    '';
    license = "free";
    platforms = stdenv.lib.platforms.linux;
  };
}
