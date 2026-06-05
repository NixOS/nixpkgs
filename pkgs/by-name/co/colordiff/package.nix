{
  lib,
  stdenv,
  fetchFromGitHub,
  docbook_xml_dtd_412,
  docbook_xsl,
  perl,
  w3m-batch,
  xmlto,
  diffutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "colordiff";
  version = "1.0.22";

  src = fetchFromGitHub {
    owner = "daveewart";
    repo = "colordiff";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZFxBY/QrKlRC7glEGWpB/79Jup0e4RCnS82Ct6lhK4Y=";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_412
    docbook_xsl
    perl
    w3m-batch
    xmlto
  ];

  buildInputs = [ perl ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'TMPDIR=colordiff-''${VERSION}' ""

    substituteInPlace colordiff.pl \
      --replace '= "diff";' '= "${diffutils}/bin/diff";'
  '';

  installFlags = [
    "INSTALL_DIR=/bin"
    "MAN_DIR=/share/man/man1"
    "DESTDIR=${placeholder "out"}"
  ];

  meta = {
    description = "Wrapper for 'diff' that produces the same output but with pretty 'syntax' highlighting";
    homepage = "https://www.colordiff.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "colordiff";
  };
})
