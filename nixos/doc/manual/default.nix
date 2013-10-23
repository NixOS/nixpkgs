{ pkgs, options
# revision can have multiple values: local, HEAD or any revision number.
, revision ? "HEAD"
}:

with pkgs.lib;

let

  # Remove invisible and internal options.
  options' = filter (opt: opt.visible && !opt.internal) (optionAttrSetToDocList options);

  # Clean up declaration sites to not refer to the NixOS source tree.
  options'' = flip map options' (opt: opt // {
    declarations = map (fn: stripPrefix fn) opt.declarations;
  });

  prefix = toString pkgs.path;

  stripPrefix = fn:
    if substring 0 (stringLength prefix) fn == prefix then
      substring (add (stringLength prefix) 1) 1000 fn
    else
      fn;

  optionsXML = builtins.toFile "options.xml" (builtins.unsafeDiscardStringContext (builtins.toXML options''));

  optionsDocBook = pkgs.runCommand "options-db.xml" {} ''
    if grep /nixpkgs/nixos/modules ${optionsXML}; then
      echo "The manual appears to depend on the location of Nixpkgs, which is bad"
      echo "since this prevents sharing via the NixOS channel.  This is typically"
      echo "caused by an option default that refers to a relative path (see above"
      echo "for hints about the offending path)."
      exit 1
    fi
    ${pkgs.libxslt}/bin/xsltproc \
      --stringparam revision '${revision}' \
      -o $out ${./options-to-docbook.xsl} ${optionsXML}
  '';

in rec {

  # Generate the NixOS manual.
  manual = pkgs.stdenv.mkDerivation {
    name = "nixos-manual";

    sources = sourceFilesBySuffices ./. [".xml"];

    buildInputs = [ pkgs.libxml2 pkgs.libxslt ];

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

      # Check the validity of the manual sources.
      xmllint --noout --nonet --xinclude --noxincludenode \
        --relaxng ${pkgs.docbook5}/xml/rng/docbook/docbook.rng \
        manual.xml

      # Generate the HTML manual.
      dst=$out/share/doc/nixos
      ensureDir $dst
      xsltproc $xsltFlags --nonet --xinclude \
        --output $dst/manual.html \
        ${pkgs.docbook5_xsl}/xml/xsl/docbook/xhtml/docbook.xsl \
        ./manual.xml

      mkdir -p $dst/images/callouts
      cp ${pkgs.docbook5_xsl}/xml/xsl/docbook/images/callouts/*.gif $dst/images/callouts/

      cp ${./style.css} $dst/style.css

      ensureDir $out/nix-support
      echo "doc manual $dst manual.html" >> $out/nix-support/hydra-build-products
    ''; # */
  };

  # Generate the NixOS manpages.
  manpages = pkgs.stdenv.mkDerivation {
    name = "nixos-manpages";

    sources = sourceFilesBySuffices ./. [".xml"];

    buildInputs = [ pkgs.libxml2 pkgs.libxslt ];

    buildCommand = ''
      ln -s $sources/*.xml . # */
      ln -s ${optionsDocBook} options-db.xml

      # Check the validity of the manual sources.
      xmllint --noout --nonet --xinclude --noxincludenode \
        --relaxng ${pkgs.docbook5}/xml/rng/docbook/docbook.rng \
        ./man-pages.xml

      # Generate manpages.
      ensureDir $out/share/man
      xsltproc --nonet --xinclude \
        --param man.output.in.separate.dir 1 \
        --param man.output.base.dir "'$out/share/man/'" \
        --param man.endnotes.are.numbered 0 \
        ${pkgs.docbook5_xsl}/xml/xsl/docbook/manpages/docbook.xsl \
        ./man-pages.xml
    '';
  };

}
