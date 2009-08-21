{ pkgs, optionDeclarations }:

let

  manualConfig =
    { environment.checkConfigurationOptions = false;
      services.nixosManual.enable = false;
    };

  # To prevent infinite recursion, remove system.path from the
  # options.  Not sure why this happens.
  optionDeclarations_ =
    optionDeclarations //
    { system = removeAttrs optionDeclarations.system ["path"]; };

  options = builtins.toFile "options.xml" (builtins.unsafeDiscardStringContext
    (builtins.toXML (pkgs.lib.optionAttrSetToDocList "" optionDeclarations_)));

  optionsDocBook = pkgs.runCommand "options-db.xml" {} ''
    ${pkgs.libxslt}/bin/xsltproc -o $out ${./options-to-docbook.xsl} ${options} 
  '';
    
  manual = pkgs.stdenv.mkDerivation {
    name = "nixos-manual";

    sources = pkgs.lib.sourceFilesBySuffices ./. [".xml"];

    buildInputs = [pkgs.libxslt];

    xsltFlags = ''
      --param section.autolabel 1
      --param section.label.includes.component.label 1
      --param html.stylesheet 'style.css'
      --param xref.with.number.and.title 1
      --param toc.section.depth 3
      --param admon.style '''
      --param callout.graphics.extension '.gif'
    '';

    buildCommand = ''
      
      ln -s $sources/*.xml .
      ln -s ${optionsDocBook} options-db.xml

      dst=$out/share/doc/nixos
      ensureDir $dst
      xsltproc $xsltFlags --nonet --xinclude \
        --output $dst/manual.html \
        ${pkgs.docbook5_xsl}/xml/xsl/docbook/xhtml/docbook.xsl \
        ./manual.xml
      ln -s ${pkgs.docbook5_xsl}/xml/xsl/docbook/images $dst/
      cp ${./style.css} $dst/style.css

      ensureDir $out/share/man
      xsltproc --nonet --xinclude \
        --param man.output.in.separate.dir 1 \
        --param man.output.base.dir "'$out/share/man/'" \
        ${pkgs.docbook5_xsl}/xml/xsl/docbook/manpages/docbook.xsl \
        ./man-pages.xml
      
      ensureDir $out/nix-support
      echo "doc manual $dst manual.html" >> $out/nix-support/hydra-build-products
    '';
  };

in manual
