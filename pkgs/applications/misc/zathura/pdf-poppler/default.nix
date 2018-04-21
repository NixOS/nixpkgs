{ stdenv, lib, fetchurl, meson, ninja, pkgconfig, zathura_core, girara, poppler }:

stdenv.mkDerivation rec {
  version = "0.2.9";
  name = "zathura-pdf-poppler-${version}";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/plugins/download/${name}.tar.xz";
    sha256 = "1p4jcny0jniygns78mcf0nlm298dszh49qpmjmackrm6dq8hc25y";
  };

  nativeBuildInputs = [ meson ninja pkgconfig zathura_core ];
  buildInputs = [ poppler girara ];

  PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = with lib; {
    homepage = https://pwmt.org/projects/zathura-pdf-poppler/;
    description = "A zathura PDF plugin (poppler)";
    longDescription = ''
      The zathura-pdf-poppler plugin adds PDF support to zathura by
      using the poppler rendering library.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan garbas ];
  };
}
