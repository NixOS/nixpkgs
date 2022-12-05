{ stdenv, lib, fetchurl, meson, ninja, pkg-config, zathura_core, girara, poppler }:

stdenv.mkDerivation rec {
  pname = "zathura-pdf-poppler";
  version = "0.3.0";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
    sha256 = "1vfl4vkyy3rf39r1sqaa7y8113bgkh2bkfq3nn2inis9mrykmk6m";
  };

  nativeBuildInputs = [ meson ninja pkg-config zathura_core ];
  buildInputs = [ poppler girara ];

  PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = with lib; {
    homepage = "https://pwmt.org/projects/zathura-pdf-poppler/";
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
