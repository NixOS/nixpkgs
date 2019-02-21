{ 
  stdenv, fetchurl, docbook_xsl,
  docbook_xml_dtd_45, python, pygments, 
  libxslt 
}:

stdenv.mkDerivation rec {
  version = "6.12.0";
  name = "csound-manual-${version}";
  
  src = fetchurl {
    url = "https://github.com/csound/manual/archive/${version}.tar.gz";
    sha256 = "1v1scp468rnfbcajnp020kdj8zigimc2mbcwzxxqi8sf8paccdrp";
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
    license = stdenv.lib.licenses.fdl12Plus;
    maintainers = [ stdenv.lib.maintainers.hlolli ];
    platforms = stdenv.lib.platforms.all;
  };
}

