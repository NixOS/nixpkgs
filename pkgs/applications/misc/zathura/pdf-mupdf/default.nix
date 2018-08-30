{ stdenv, lib, meson, ninja, fetchurl, pkgconfig, zathura_core, cairo,
gtk-mac-integration, girara, mupdf }:

stdenv.mkDerivation rec {
  version = "0.3.3";
  name = "zathura-pdf-mupdf-${version}";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-pdf-mupdf/download/${name}.tar.xz";
    sha256 = "1zbdqimav4wfgimpy3nfzl10qj7vyv23rdy2z5z7z93jwbp2rc2j";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    zathura_core girara mupdf cairo
  ] ++ stdenv.lib.optional stdenv.isDarwin [
    gtk-mac-integration
  ];

  PKG_CONFIG_ZATHURA_PLUGINDIR= "lib/zathura";

  meta = with lib; {
    homepage = https://pwmt.org/projects/zathura-pdf-mupdf/;
    description = "A zathura PDF plugin (mupdf)";
    longDescription = ''
      The zathura-pdf-mupdf plugin adds PDF support to zathura by
      using the mupdf rendering library.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan ];
  };
}
