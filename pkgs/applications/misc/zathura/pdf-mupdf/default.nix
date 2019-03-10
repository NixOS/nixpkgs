{ stdenv, lib, meson, ninja, fetchurl, fetchFromGitHub
, pkgconfig, zathura_core, cairo , gtk-mac-integration, girara, mupdf }:

stdenv.mkDerivation rec {
  version = "0.3.4";
  name = "zathura-pdf-mupdf-${version}";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-pdf-mupdf/download/${name}.tar.xz";
    sha256 = "166d5nz47ixzwj4pixsd5fd9qvjf5v34cdqi3p72vr23pswk2hyn";
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
