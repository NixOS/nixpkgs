{
  lib,
  stdenv,
  cdk,
  unzip,
  gtk2,
  glib,
  ncurses,
  pkg-config,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtdialog";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "orbitalquark";
    repo = "gtdialog";
    rev = "gtdialog_${finalAttrs.version}";
    hash = "sha256-TdYwT4bC+crTSNGJIr1Nno+/h1YgxNp0BR5MQtxdrVg=";
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
})
