{ stdenv, lib, fetchurl, meson, ninja, pkgconfig, zathura_core, girara, poppler }:

stdenv.mkDerivation rec {
  pname = "zathura-pdf-poppler";
  version = "0.3.0";

  src = fetchurl {
    url = "https://git.pwmt.org/pwmt/zathura-pdf-poppler/-/archive/${version}/${pname}-${version}.tar.gz";
    sha256 = "133xxh82x37v0ihwk5g2hih1xlzm76kkayifdjn15xqf14gp6axs";
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
