{ stdenv, fetchurl, pkgconfig, gtk, gettext }:

stdenv.mkDerivation rec {
  name = "girara-0.1.5";

  src = fetchurl {
    url = "http://pwmt.org/projects/girara/download/${name}.tar.gz";
    sha256 = "1hfi3jmx8ydvrqm3h6p6py2csavh7xx0223vxyca51kjl9mfnbld";
  };

  buildInputs = [ pkgconfig gtk gettext ];

  makeFlags = "PREFIX=$(out)";

  meta = {
    homepage = http://pwmt.org/projects/girara/;
    description = "User interface library";
    longDescription = ''
      girara is a library that implements a GTK+ based VIM-like user interface
      that focuses on simplicity and minimalism.
    '';
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.garbas ];
  };
}

