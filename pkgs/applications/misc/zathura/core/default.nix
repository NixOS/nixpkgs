{ stdenv, fetchurl, pkgconfig, gtk, girara, gettext, docutils, file, makeWrapper, zathura_icon }:

stdenv.mkDerivation rec {
  version = "0.2.9";
  name = "zathura-core-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/download/zathura-${version}.tar.gz";
    sha256 = "17z05skjk95115ajp6459k1djadza1w8kck7jn1qnd697r01s1rc";
  };

  buildInputs = [ pkgconfig file gtk girara gettext makeWrapper ];

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
