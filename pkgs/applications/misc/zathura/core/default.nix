{ stdenv, fetchurl, pkgconfig, gtk, girara, gettext, docutils }:

stdenv.mkDerivation rec {

  version = "0.2.1";

  name = "zathura-core-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/download/zathura-${version}.tar.gz";
    sha256 = "075b9def201c77ca738dc9e15b252bc23c085b7c4671a1810d1d962e8d0bd790";
  };

  buildInputs = [ pkgconfig gtk girara gettext ];

  # Workaround bug in zathura build system: remove empty manfiles
  preBuild = ''
    rm zathura.1
    rm zathurarc.5
  '';

  makeFlags = [ "PREFIX=$(out)" "RSTTOMAN=${docutils}/bin/rst2man.py" "VERBOSE=1" ];

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
