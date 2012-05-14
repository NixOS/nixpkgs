{ stdenv, fetchurl, pkgconfig, gtk, gettext }:

stdenv.mkDerivation rec {
  name = "girara-0.1.2";

  src = fetchurl {
    url = "http://pwmt.org/projects/girara/download/${name}.tar.gz";
    sha256 = "89231d0da3c790e0765ad85d74f64cf50051b8bafe6065882e34e378ab14ec99";
  };

  buildInputs = [ pkgconfig gtk gettext ];

  makeFlags = "PREFIX=$(out)";

  meta = {
    homepage = https://pwmt.org/girara/;
    description = "User interface library";
    longDescription = ''
      girara is a library that implements a GTK+ based VIM-like user interface
      that focuses on simplicity and minimalism.
    '';
    license = "free";
    platforms = stdenv.lib.platforms.linux;
  };
}

