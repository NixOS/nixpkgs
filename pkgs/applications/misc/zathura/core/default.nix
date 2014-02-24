{ stdenv, fetchurl, pkgconfig, gtk, girara, gettext, docutils, file, makeWrapper, zathura_icon }:

stdenv.mkDerivation rec {
  version = "0.2.7";
  name = "zathura-core-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/download/zathura-${version}.tar.gz";
    sha256 = "ef43be7705612937d095bfbe719a03503bf7e45493ea9409cb43a45cf96f0daf";
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
    wrapProgram "$out/bin/zathura" \
      --prefix PATH ":" "${file}/bin" \
      --prefix XDG_CONFIG_DIRS ":" "$out/etc"

    mkdir -pv $out/etc
    echo "set window-icon ${zathura_icon}" > $out/etc/zathurarc
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
