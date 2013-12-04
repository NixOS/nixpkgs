{ stdenv, fetchurl, pkgconfig, gtk, girara, gettext, docutils, file, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.2.5";
  name = "zathura-core-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/download/zathura-${version}.tar.gz";
    sha256 = "1lw9q0x4b7x6z86hwgs93f8srimd0sj8fwg91185f63yz9g800fr";
  };

  buildInputs = [ pkgconfig file gtk girara gettext makeWrapper ];

  # Bug in zathura build system: we should remove empty manfiles in order them
  # to be compiled properly
  preBuild = ''
    rm zathura.1
    rm zathurarc.5
  '';

  makeFlags = [ "PREFIX=$(out)" "RSTTOMAN=${docutils}/bin/rst2man.py" "VERBOSE=1" ];

  postInstall = ''
    wrapProgram "$out/bin/zathura" --prefix PATH ":" "${file}/bin"
  '';

  meta = {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.garbas ];

    # Set lower priority in order to provide user with a wrapper script called
    # 'zathura' instead of real zathura executable. The wrapper will build
    # plugin path argument before executing the original.
    priority = 1;
  };
}
