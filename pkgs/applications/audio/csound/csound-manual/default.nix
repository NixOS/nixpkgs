{
  lib, stdenv, fetchFromGitHub, docbook_xsl,
  docbook_xml_dtd_45, python, pygments,
  libxslt
}:

stdenv.mkDerivation {
  pname = "csound-manual";
  version = "unstable-2019-02-22";

  src = fetchFromGitHub {
    owner = "csound";
    repo = "manual";
    rev = "3b0bdc83f9245261b4b85a57c3ed636d5d924a4f";
    sha256 = "074byjhaxraapyg54dxgg7hi1d4978aa9c1rmyi50p970nsxnacn";
  };

  prePatch = ''
    substituteInPlace manual.xml \
      --replace "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
                "${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd"
  '';

  nativeBuildInputs = [ libxslt.bin ];

  buildInputs = [ docbook_xsl python pygments ];

  buildPhase = ''
    make XSL_BASE_PATH=${docbook_xsl}/share/xml/docbook-xsl html-dist
  '';

  installPhase = ''
    mkdir -p $out/share/doc/csound
    cp -r ./html $out/share/doc/csound
  '';

  meta = {
    description = "The Csound Canonical Reference Manual";
    homepage = "https://github.com/csound/manual";
    license = lib.licenses.fdl12Plus;
    maintainers = [ lib.maintainers.hlolli ];
    platforms = lib.platforms.all;
  };
}
