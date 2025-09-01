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

  meta = with lib; {
    description = "Cross-platform helper for creating interactive dialogs";
    mainProgram = "gtdialog";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "http://foicica.com/gtdialog";
    downloadPage = "http://foicica.com/gtdialog/download";
  };
}
