{ stdenv, fetchurl, pkgconfig, gtk, gettext }:

stdenv.mkDerivation rec {
  name = "girara-0.1.4";

  src = fetchurl {
    url = "http://pwmt.org/projects/girara/download/${name}.tar.gz";
    sha256 = "831cf523b131bfa1c182efbf146d68fb642fe62d22ee199caf0cd71408a85739";
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
    license = "free";
    platforms = stdenv.lib.platforms.linux;
  };
}

