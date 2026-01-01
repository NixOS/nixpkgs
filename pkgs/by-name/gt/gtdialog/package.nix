{
  lib,
  stdenv,
<<<<<<< HEAD
=======
  fetchurl,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cdk,
  unzip,
  gtk2,
  glib,
  ncurses,
  pkg-config,
<<<<<<< HEAD
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
=======
}:

stdenv.mkDerivation rec {
  pname = "gtdialog";
  version = "1.4";

  src = fetchurl {
    url = "https://foicica.com/gtdialog/download/gtdialog_${version}.zip";
    sha256 = "sha256-0+WBr1IZIhQjxOsKO/yuXjaTRWPObhMdGqgibcpXGtI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
