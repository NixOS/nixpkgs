{pkgs}:

let

  manualConfig =
    { environment.checkConfigurationOptions = false;
    };

  options = builtins.toFile "options.xml" (builtins.unsafeDiscardStringContext
    (builtins.toXML (pkgs.lib.optionAttrSetToDocList ""
      (import ../../lib/eval-config.nix {inherit pkgs; configuration = manualConfig;}).optionDeclarations)));

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
      ensureDir $out
      ln -s $sources/*.xml .
      ln -s ${optionsDocBook} options-db.xml
      xsltproc $xsltFlags --nonet --xinclude \
        --output $out/manual.html \
        ${pkgs.docbook5_xsl}/xml/xsl/docbook/xhtml/docbook.xsl \
        ./manual.xml
      ln -s ${pkgs.docbook5_xsl}/xml/xsl/docbook/images $out/
      cp ${./style.css} $out/style.css
      
      ensureDir $out/nix-support
      echo "doc manual $out manual.html" >> $out/nix-support/hydra-build-products
    '';
  };

in manual
