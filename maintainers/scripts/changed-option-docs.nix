/*
  Renders only changed NixOS options.

  Caveats:

    - Does not allow the testing of local links to the manual or other options.
    - It may prioritize speed over correctness. If you want to a guaranteed
      100% correct PR, you should always do a full build of the manual, but we
      believe that a fast check has a right to exist. Any semi-structural
      issues that do arise can be fixed.
    - Only works for NixOS system options, not test options or Nixpkgs config options.

  Example usage:

    # since ref
    nix-build ./maintainers/scripts/changed-option-docs.nix --argstr baseRef upstream/master

    # open browser
    xdg-open result/index.html

    # since commit sha
    nix-build ./maintainers/scripts/changed-option-docs.nix --argstr baseRef a509e0fcb5

    # since last two commits
    nix-build ./maintainers/scripts/changed-option-docs.nix --argstr baseRef $(git show HEAD~2 --format=%H)

 */

args@
{ baseRef ? "upstream/master"
, base ? builtins.fetchGit { url = toString ../..; ref = baseRef; }
, system ? builtins.currentSystem
, lib ? import ../../lib
, pkgs ? import ../.. { inherit system; overlays = []; config = {}; }
}:

let
  getOpts = nixpkgs:
    let release = import (nixpkgs + "/nixos/release.nix") { hydraJob = drv: drv; };
    in release.manual.${system}.optionsDoc.optionsNix;
  currentOpts = getOpts ../..;
  baseOpts = getOpts base;
  isNew = name: newValue: !baseOpts?${name} || baseOpts.${name} != currentOpts.${name};
  newOpts = lib.filterAttrs isNew currentOpts;

  newOptionsDoc = pkgs.nixosOptionsDoc {
    optionsNix = newOpts;
    inherit lib pkgs;
    options = throw "changed-option-docs: options should be unused";
  };

  # FIXME: copied from nixos/doc/manual/default.nix
  toc = builtins.toFile "toc.xml"
    ''
      <toc role="chunk-toc">
        <d:tocentry xmlns:d="http://docbook.org/ns/docbook" linkend="book-nixos-manual"><?dbhtml filename="index.html"?>
          <d:tocentry linkend="ch-options"><?dbhtml filename="options.html"?></d:tocentry>
          <d:tocentry linkend="ch-release-notes"><?dbhtml filename="release-notes.html"?></d:tocentry>
        </d:tocentry>
      </toc>
    '';

  # FIXME: copied from nixos/doc/manual/default.nix
  manualXsltprocOptions = toString [
    "--param section.autolabel 1"
    "--param section.label.includes.component.label 1"
    "--stringparam html.stylesheet 'style.css overrides.css highlightjs/mono-blue.css'"
    "--stringparam html.script './highlightjs/highlight.pack.js ./highlightjs/loader.js'"
    "--param xref.with.number.and.title 1"
    "--param toc.section.depth 0"
    "--param generate.consistent.ids 1"
    "--stringparam admon.style ''"
    "--stringparam callout.graphics.extension .svg"
    "--stringparam current.docid manual"
    "--param chunk.section.depth 0"
    "--param chunk.first.sections 1"
    "--param use.id.as.filename 1"
    "--stringparam chunk.toc ${toc}"
  ];

  # TODO: refactor the NixOS documentation build so that the options part is
  #       rendered in a separate derivation, that we can invoke here.
  #       Such a split build will have to defer link checks until the manual
  #       is combined.
  docbookHtml = pkgs.runCommand "new-options" {
    optionsDb = newOptionsDoc.optionsDocBook;
    nativeBuildInputs = [ pkgs.libxslt.bin ];
  } ''
    dst=$out
    mkdir -p $dst
    # FIXME    --stringparam target.database.document "$olinkDB}/olinkdb.xml" \
    xsltproc \
        ${manualXsltprocOptions} \
        --stringparam id.warnings "1" \
        --stringparam target.database.document "olinkdb.xml" \
        --nonet --output index.html.part \
        ${pkgs.docbook_xsl_ns}/xml/xsl/docbook/xhtml/chunktoc.xsl \
        $optionsDb

    cp $optionsDb $dst/options-docbook.xml

    # FIXME: copied from nixos/doc/manual/default.nix
    cp ${../../doc/style.css} $dst/style.css
    cp ${../../doc/overrides.css} $dst/overrides.css
    cp -r ${pkgs.documentation-highlighter} $dst/highlightjs
    { echo '<html><head><title>Added or Modified Options</title>'
      echo '<link href="style.css" rel="stylesheet" type="text/css"/>'
      echo '<link href="overrides.css" rel="stylesheet" type="text/css"/>'
      echo '</head><body>'
      cat index.html.part | sed -e 's/<?xml[^?]*?>//'
      echo '</body></html>'
    } >$dst/index.html
  '';

in
  # newOptionsDoc.optionsDocBook
  docbookHtml
