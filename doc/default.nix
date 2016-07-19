let
  pkgs = import ./.. { };
  lib = pkgs.lib;
  sources = lib.sourceFilesBySuffices ./. [".xml"];
  sources-langs = ./languages-frameworks;
in
pkgs.stdenv.mkDerivation {
  name = "nixpkgs-manual";


  buildInputs = with pkgs; [ pandoc libxml2 libxslt zip ];

  xsltFlags = ''
    --param section.autolabel 1
    --param section.label.includes.component.label 1
    --param html.stylesheet 'style.css'
    --param xref.with.number.and.title 1
    --param toc.section.depth 3
    --param admon.style '''
    --param callout.graphics.extension '.gif'
  '';


  buildCommand = let toDocbook = { useChapters ? false, inputFile, outputFile }:
    let
      extraHeader = ''xmlns="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink" '';
    in ''
      {
        pandoc '${inputFile}' -w docbook ${lib.optionalString useChapters "--chapters"} \
          --smart \
          | sed -e 's|<ulink url=|<link xlink:href=|' \
              -e 's|</ulink>|</link>|' \
              -e 's|<sect. id=|<section xml:id=|' \
              -e 's|</sect[0-9]>|</section>|' \
              -e '1s| id=| xml:id=|' \
              -e '1s|\(<[^ ]* \)|\1${extraHeader}|'
      } > '${outputFile}'
    '';
  in

  ''
    ln -s '${sources}/'*.xml .
    mkdir ./languages-frameworks
    cp -s '${sources-langs}'/* ./languages-frameworks
  ''
  + toDocbook {
      inputFile = ./introduction.md;
      outputFile = "introduction.xml";
      useChapters = true;
    }
  + toDocbook {
      inputFile = ./languages-frameworks/python.md;
      outputFile = "./languages-frameworks/python.xml";
    }
  + toDocbook {
      inputFile = ./languages-frameworks/haskell.md;
      outputFile = "./languages-frameworks/haskell.xml";
    }
  + toDocbook {
      inputFile = ../pkgs/development/idris-modules/README.md;
      outputFile = "languages-frameworks/idris.xml";
    }
  + toDocbook {
      inputFile = ../pkgs/development/r-modules/README.md;
      outputFile = "languages-frameworks/r.xml";
    }
  + ''
    echo ${lib.nixpkgsVersion} > .version

    # validate against relaxng schema
    xmllint --nonet --xinclude --noxincludenode manual.xml --output manual-full.xml
    ${pkgs.jing}/bin/jing ${pkgs.docbook5}/xml/rng/docbook/docbook.rng manual-full.xml

    dst=$out/share/doc/nixpkgs
    mkdir -p $dst
    xsltproc $xsltFlags --nonet --xinclude \
      --output $dst/manual.html \
      ${pkgs.docbook5_xsl}/xml/xsl/docbook/xhtml/docbook.xsl \
      ./manual.xml

    cp ${./style.css} $dst/style.css

    mkdir -p $dst/images/callouts
    cp "${pkgs.docbook5_xsl}/xml/xsl/docbook/images/callouts/"*.gif $dst/images/callouts/

    mkdir -p $out/nix-support
    echo "doc manual $dst manual.html" >> $out/nix-support/hydra-build-products

    xsltproc $xsltFlags --nonet --xinclude \
      --output $dst/epub/ \
      ${pkgs.docbook5_xsl}/xml/xsl/docbook/epub/docbook.xsl \
      ./manual.xml

    cp -r $dst/images $dst/epub/OEBPS
    echo "application/epub+zip" > mimetype
    zip -0Xq  "$dst/Nixpkgs Contributors Guide - NixOS community.epub" mimetype
    zip -Xr9D "$dst/Nixpkgs Contributors Guide - NixOS community.epub" $dst/epub/*
  '';
}
