{
  lib,
  stdenv,
  fetchpatch,
  perlPackages,
  shortenPerlShebang,
  texlive,
}:

let
  biberSource = texlive.pkgs.biber.texsource;
in

perlPackages.buildPerlModule {
  inherit (biberSource) pname version;

  src = "${biberSource}/source/bibtex/biber/biblatex-biber.tar.gz";

  # Test suite checks years that are out of range with 32bit integers
  patches = lib.optionals stdenv.hostPlatform.is32bit [
    (fetchpatch {
      name = "biber-skip-64bit-only-tests.patch";
      url = "https://raw.githubusercontent.com/gentoo/gentoo/65871ad2d20b8ab39caf25a0aaec3ab95fbcf511/dev-tex/biber/files/biber-2.16-disable-64bit-only-tests.patch";
      hash = "sha256-6Tbp62uZuFPoSKZrXerObg+gcSyLwC66IAcvcP+KcHM=";
    })
  ];

  buildInputs = with perlPackages; [
    autovivification
    BusinessISBN
    BusinessISMN
    BusinessISSN
    ConfigAutoConf
    DataCompare
    DataDump
    DateSimple
    EncodeEUCJPASCII
    EncodeHanExtra
    EncodeJIS2K
    DateTime
    DateTimeFormatBuilder
    DateTimeCalendarJulian
    ExtUtilsLibBuilder
    FileSlurper
    FileWhich
    IPCRun3
    LogLog4perl
    LWPProtocolHttps
    ListAllUtils
    ListMoreUtils
    MozillaCA
    ParseRecDescent
    IOString
    ReadonlyXS
    RegexpCommon
    TextBibTeX
    UnicodeLineBreak
    URI
    XMLLibXMLSimple
    XMLLibXSLT
    XMLWriter
    ClassAccessor
    TextCSV
    TextCSV_XS
    TextRoman
    DataUniqid
    LinguaTranslit
    SortKey
    TestDifferences
    PerlIOutf8_strict
  ];
  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin shortenPerlShebang;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    shortenPerlShebang $out/bin/biber
  '';

  meta = with lib; {
    description = "Backend for BibLaTeX";
    license = biberSource.meta.license;
    platforms = platforms.unix;
    maintainers = [ maintainers.ttuegel ];
    mainProgram = "biber";
  };
}
