{
  lib,
  stdenv,
  fetchurl,
  cdk,
  unzip,
  gtk2,
  glib,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "gtdialog";
  version = "1.4";

  src = fetchurl {
    url = "https://foicica.com/gtdialog/download/gtdialog_${version}.zip";
    sha256 = "sha256-0+WBr1IZIhQjxOsKO/yuXjaTRWPObhMdGqgibcpXGtI=";
  };

  nativeBuildInputs = [
    pkg-config
    unzip
  ];
  buildInputs = [
    cdk
    gtk2
    glib
    ncurses
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Cross-platform helper for creating interactive dialogs";
    mainProgram = "gtdialog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    homepage = "http://foicica.com/gtdialog";
    downloadPage = "http://foicica.com/gtdialog/download";
  };
}
