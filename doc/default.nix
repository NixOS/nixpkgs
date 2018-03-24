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
      extraHeader = lib.optionalString (!useChapters)
        ''xmlns="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink" '';
    in ''
      {
        pandoc '${inputFile}' -w docbook+smart ${lib.optionalString useChapters "--top-level-division=chapter"} \
          -f markdown+smart \
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
      inputFile = ./introduction.chapter.md;
      outputFile = "introduction.chapter.xml";
      useChapters = true;
    }
  + toDocbook {
      inputFile = ./shell.section.md;
      outputFile = "shell.section.xml";
    }
  + toDocbook {
      inputFile = ./languages-frameworks/python.section.md;
      outputFile = "./languages-frameworks/python.section.xml";
    }
  + toDocbook {
      inputFile = ./languages-frameworks/haskell.section.md;
      outputFile = "./languages-frameworks/haskell.section.xml";
    }
  + toDocbook {
      inputFile = ./languages-frameworks/idris.section.md;
      outputFile = "languages-frameworks/idris.section.xml";
    }
  + toDocbook {
      inputFile = ./languages-frameworks/node.section.md;
      outputFile = "languages-frameworks/node.section.xml";
    }
  + toDocbook {
      inputFile = ./languages-frameworks/r.section.md;
      outputFile = "languages-frameworks/r.section.xml";
    }
  + toDocbook {
      inputFile = ./languages-frameworks/rust.section.md;
      outputFile = "./languages-frameworks/rust.section.xml";
    }
  + toDocbook {
      inputFile = ./languages-frameworks/vim.section.md;
      outputFile = "./languages-frameworks/vim.section.xml";
    }
  + ''
    echo ${lib.nixpkgsVersion} > .version
  '';

  installPhase = ''
    dest="$out/share/doc/nixpkgs"
    mkdir -p "$(dirname "$dest")"
    mv out/html "$dest"
    mv "$dest/index.html" "$dest/manual.html"

    mv out/epub/manual.epub "$dest/nixpkgs-manual.epub"

    mkdir -p $out/nix-support/
    echo "doc manual $dest manual.html" >> $out/nix-support/hydra-build-products
  '';
}
