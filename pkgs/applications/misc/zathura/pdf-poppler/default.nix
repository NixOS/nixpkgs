{ stdenv, lib, fetchurl, meson, ninja, pkgconfig, zathura_core, girara, poppler }:

stdenv.mkDerivation rec {
  version = "0.2.9";
  name = "zathura-pdf-poppler-${version}";

  src = fetchurl {
    url = "https://git.pwmt.org/pwmt/zathura-pdf-poppler/-/archive/${version}/${name}.tar.gz";
    sha256 = "0c15rnwh42m3ybrhax01bl36w0iynaq8xg6l08riml3cyljypi9l";
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
    maintainers = with maintainers; [ cstrahan ];
  };
}
