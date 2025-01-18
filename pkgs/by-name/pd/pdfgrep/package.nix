{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  poppler,
  libgcrypt,
  pcre2,
  asciidoc,
}:

stdenv.mkDerivation rec {
  pname = "pdfgrep";
  version = "2.2.0";

  src = fetchurl {
    url = "https://pdfgrep.org/download/${pname}-${version}.tar.gz";
    hash = "sha256-BmHlMeTA7wl5Waocl3N5ZYXbOccshKAv+H0sNjfGIMs=";
  };

  postPatch = ''
    for i in ./src/search.h ./src/pdfgrep.cc ./src/search.cc; do
      substituteInPlace $i --replace '<cpp/' '<'
    done
  '';

  configureFlags = [
    "--with-libgcrypt-prefix=${lib.getDev libgcrypt}"
  ];

  nativeBuildInputs = [
    pkg-config
    asciidoc
  ];
  buildInputs = [
    poppler
    libgcrypt
    pcre2
  ];

  meta = with lib; {
    description = "Commandline utility to search text in PDF files";
    homepage = "https://pdfgrep.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      qknight
      fpletz
    ];
    platforms = with platforms; unix;
    mainProgram = "pdfgrep";
  };
}
