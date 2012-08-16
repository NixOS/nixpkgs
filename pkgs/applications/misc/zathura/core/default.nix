{ stdenv, fetchurl, pkgconfig, gtk, girara, gettext }:

stdenv.mkDerivation rec {

  version = "0.1.2";

  name = "zathura-core-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/download/zathura-${version}.tar.gz";
    sha256 = "a496c25071e54f675b65ee5eab02fd002c04c2d7d5cf4aa8a1cb517cc13beaef";
  };

  buildInputs = [ pkgconfig gtk girara gettext ];

  makeFlags = "PREFIX=$(out)";

  meta = {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license = "free";
    platforms = stdenv.lib.platforms.linux;

    # Set lower priority in order to provide user with a wrapper script called
    # 'zathura' instead of real zathura executable. The wrapper will build
    # plugin path argument before executing the original.
    priority = 1;
  };
}
