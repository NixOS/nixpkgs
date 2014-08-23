{ stdenv, fetchurl, pkgconfig, gtk, gettext }:

stdenv.mkDerivation rec {
  name = "girara-0.2.2";

  src = fetchurl {
    url = "http://pwmt.org/projects/girara/download/${name}.tar.gz";
    sha256 = "0lv6wqhx2avdxj6yx111jfs4j32r0xzmmkhy7pgzxpf73kgxz0k3";
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

