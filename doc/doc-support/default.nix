{ pkgs ? (import ../.. {}), nixpkgs ? { }}:
let
  locationsXml = import ./lib-function-locations.nix { inherit pkgs nixpkgs; };
  functionDocs = import ./lib-function-docs.nix { inherit locationsXml pkgs; };
  version = pkgs.lib.version;

  epub-xsl = pkgs.writeText "epub.xsl" ''
    <?xml version='1.0'?>
    <xsl:stylesheet
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      version="1.0">
      <xsl:import href="${pkgs.docbook_xsl_ns}/xml/xsl/docbook/epub/docbook.xsl" />
      <xsl:import href="${./parameters.xml}"/>
    </xsl:stylesheet>
  '';

  xhtml-xsl = pkgs.writeText "xhtml.xsl" ''
    <?xml version='1.0'?>
    <xsl:stylesheet
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      version="1.0">
      <xsl:import href="${pkgs.docbook_xsl_ns}/xml/xsl/docbook/xhtml/docbook.xsl" />
      <xsl:import href="${./parameters.xml}"/>
    </xsl:stylesheet>
  '';
in pkgs.runCommand "doc-support" {}
''
  mkdir result
  (
    cd result
    ln -s ${locationsXml} ./function-locations.xml
    ln -s ${functionDocs} ./function-docs

    ln -s ${pkgs.docbook5}/xml/rng/docbook/docbook.rng ./docbook.rng
    ln -s ${pkgs.docbook_xsl_ns}/xml/xsl ./xsl
    ln -s ${epub-xsl} ./epub.xsl
    ln -s ${xhtml-xsl} ./xhtml.xsl

    ln -s ${../../nixos/doc/xmlformat.conf} ./xmlformat.conf
    ln -s ${pkgs.documentation-highlighter} ./highlightjs

    echo -n "${version}" > ./version
  )
  mv result $out
''
