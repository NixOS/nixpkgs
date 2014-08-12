{ pkgs, options, version, revision }:

with pkgs;
with pkgs.lib;

let

  # Remove invisible and internal options.
  options' = filter (opt: opt.visible && !opt.internal) (optionAttrSetToDocList options);

  # Clean up declaration sites to not refer to the NixOS source tree.
  options'' = flip map options' (opt: opt // {
    declarations = map (fn: stripPrefix fn) opt.declarations;
  });

  prefix = toString ../../..;

  stripPrefix = fn:
    if substring 0 (stringLength prefix) fn == prefix then
      substring (stringLength prefix + 1) 1000 fn
    else
      fn;

  optionsXML = builtins.toFile "options.xml" (builtins.unsafeDiscardStringContext (builtins.toXML options''));

  optionsDocBook = runCommand "options-db.xml" {} ''
    if grep /nixpkgs/nixos/modules ${optionsXML}; then
      echo "The manual appears to depend on the location of Nixpkgs, which is bad"
      echo "since this prevents sharing via the NixOS channel.  This is typically"
      echo "caused by an option default that refers to a relative path (see above"
      echo "for hints about the offending path)."
      exit 1
    fi
    ${libxslt}/bin/xsltproc \
      --stringparam revision '${revision}' \
      -o $out ${./options-to-docbook.xsl} ${optionsXML}
  '';

in rec {

  # Generate the NixOS manual.
  manual = stdenv.mkDerivation {
    name = "nixos-manual";

    sources = sourceFilesBySuffices ./. [".xml"];

    buildInputs = [ libxml2 libxslt ];

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
      ln -s $sources/*.xml . # */
      ln -s ${optionsDocBook} options-db.xml
      echo "${version}" > version

      # Check the validity of the manual sources.
      xmllint --noout --nonet --xinclude --noxincludenode \
        --relaxng ${docbook5}/xml/rng/docbook/docbook.rng \
        manual.xml

      # Generate the HTML manual.
      dst=$out/share/doc/nixos
      mkdir -p $dst
      xsltproc $xsltFlags --nonet --xinclude \
        --output $dst/manual.html \
        ${docbook5_xsl}/xml/xsl/docbook/xhtml/docbook.xsl \
        ./manual.xml

      mkdir -p $dst/images/callouts
      cp ${docbook5_xsl}/xml/xsl/docbook/images/callouts/*.gif $dst/images/callouts/

      cp ${./style.css} $dst/style.css

      mkdir -p $out/nix-support
      echo "nix-build out $out" >> $out/nix-support/hydra-build-products
      echo "doc manual $dst manual.html" >> $out/nix-support/hydra-build-products
    ''; # */

    meta.description = "The NixOS manual in HTML format";
  };

  manualPDF = stdenv.mkDerivation {
    name = "nixos-manual-pdf";

    sources = sourceFilesBySuffices ./. [".xml"];

    buildInputs = [ libxml2 libxslt dblatex tetex ];

    buildCommand = ''
      # TeX needs a writable font cache.
      export VARTEXFONTS=$TMPDIR/texfonts

      ln -s $sources/*.xml . # */
      ln -s ${optionsDocBook} options-db.xml
      echo "${version}" > version

      dst=$out/share/doc/nixos
      mkdir -p $dst
      xmllint --xinclude manual.xml | dblatex -o $dst/manual.pdf - \
        -P doc.collab.show=0 \
        -P latex.output.revhistory=0

      mkdir -p $out/nix-support
      echo "doc-pdf manual $dst/manual.pdf" >> $out/nix-support/hydra-build-products
    ''; # */
  };

  # Generate the NixOS manpages.
  manpages = stdenv.mkDerivation {
    name = "nixos-manpages";

    sources = sourceFilesBySuffices ./. [".xml"];

    buildInputs = [ libxml2 libxslt ];

    buildCommand = ''
      ln -s $sources/*.xml . # */
      ln -s ${optionsDocBook} options-db.xml

      # Check the validity of the manual sources.
      xmllint --noout --nonet --xinclude --noxincludenode \
        --relaxng ${docbook5}/xml/rng/docbook/docbook.rng \
        ./man-pages.xml

      # Generate manpages.
      mkdir -p $out/share/man
      xsltproc --nonet --xinclude \
        --param man.output.in.separate.dir 1 \
        --param man.output.base.dir "'$out/share/man/'" \
        --param man.endnotes.are.numbered 0 \
        ${docbook5_xsl}/xml/xsl/docbook/manpages/docbook.xsl \
        ./man-pages.xml
    '';
  };

}
