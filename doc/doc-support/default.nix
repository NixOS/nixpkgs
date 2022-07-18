{ pkgs ? (import ../.. {}), nixpkgs ? { }}:
let
  inherit (pkgs) lib;
  inherit (lib) hasPrefix removePrefix;

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

  # NB: This file describes the Nixpkgs manual, which happens to use module
  #     docs infra originally developed for NixOS.
  optionsDoc = pkgs.nixosOptionsDoc {
    inherit (pkgs.lib.evalModules { modules = [ ../../pkgs/top-level/config.nix ]; }) options;
    documentType = "none";
    transformOptions = opt:
      opt // {
        declarations =
          map
            (decl:
              if hasPrefix (toString ../..) (toString decl)
              then
                let subpath = removePrefix "/" (removePrefix (toString ../..) (toString decl));
                in { url = "https://github.com/NixOS/nixpkgs/blob/master/${subpath}"; name = subpath; }
              else decl)
            opt.declarations;
        };
  };

in pkgs.runCommand "doc-support" {}
''
  mkdir result
  (
    cd result
    ln -s ${locationsXml} ./function-locations.xml
    ln -s ${functionDocs} ./function-docs
    ln -s ${optionsDoc.optionsDocBook} ./config-options.docbook.xml

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
