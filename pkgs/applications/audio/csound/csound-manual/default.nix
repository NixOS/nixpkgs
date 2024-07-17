{
  lib,
  stdenv,
  fetchFromGitHub,
  docbook_xsl,
  docbook_xml_dtd_45,
  python3,
  libxslt,
}:

stdenv.mkDerivation rec {
  pname = "csound-manual";
  version = "6.18.0";

  src = fetchFromGitHub {
    owner = "csound";
    repo = "manual";
    rev = version;
    sha256 = "sha256-W8MghqUBr3V7LPgNwU6Ugw16wdK3G37zAPuasMlZ2+I=";
  };

  prePatch = ''
    substituteInPlace manual.xml \
      --replace "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
                "${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd"
  '';

  nativeBuildInputs = [
    libxslt.bin
    docbook_xsl
    python3
    python3.pkgs.pygments
  ];

  buildPhase = ''
    make XSL_BASE_PATH=${docbook_xsl}/share/xml/docbook-xsl html-dist
  '';

  installPhase = ''
    mkdir -p $out/share/doc/csound
    cp -r ./html $out/share/doc/csound
  '';

  meta = with lib; {
    description = "The Csound Canonical Reference Manual";
    homepage = "https://github.com/csound/manual";
    license = licenses.fdl12Plus;
    maintainers = with maintainers; [ hlolli ];
    platforms = lib.platforms.all;
  };
}
