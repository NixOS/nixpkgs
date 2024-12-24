{
  lib,
  stdenv,
  autoreconfHook,
  cyrus_sasl,
  docbook_xml_dtd_43,
  docbook_xsl,
  fetchFromGitLab,
  libkrb5,
  libxslt,
  openldap,
  pkg-config,
  util-linux,
  xmlto,
}:

stdenv.mkDerivation rec {
  pname = "adcli";
  version = "0.9.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "realmd";
    repo = "adcli";
    rev = version;
    hash = "sha256-dipNKlIdc1DpXLg/YJjUxZlNoMFy+rt8Y/+AfWFA4dE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook_xsl
    pkg-config
    util-linux
    xmlto
  ];

  buildInputs = [
    cyrus_sasl
    libkrb5
    libxslt
    openldap
  ];

  configureFlags = [ "--disable-debug" ];

  postPatch = ''
    substituteInPlace tools/Makefile.am \
      --replace-fail 'sbin_PROGRAMS' 'bin_PROGRAMS'

    substituteInPlace doc/Makefile.am \
      --replace-fail 'http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl' \
                     '${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl'

    function patch_docbook() {
      substituteInPlace $1 \
        --replace-fail "http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd" \
                       "${docbook_xml_dtd_43}/xml/dtd/docbook/docbookx.dtd"
    }
    patch_docbook doc/adcli.xml
    patch_docbook doc/adcli-devel.xml
    patch_docbook doc/adcli-docs.xml
  '';

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/realmd/adcli/adcli.html";
    description = "Helper library and tools for Active Directory client operations";
    mainProgram = "adcli";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [
      SohamG
      anthonyroussel
    ];
    platforms = platforms.linux;
  };
}
