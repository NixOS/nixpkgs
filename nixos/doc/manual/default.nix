{ pkgs, options, version, revision, extraSources ? [] }:

with pkgs;
with pkgs.lib;

let

  # Remove invisible and internal options.
  optionsList = filter (opt: opt.visible && !opt.internal) (optionAttrSetToDocList options);

  # Replace functions by the string <function>
  substFunction = x:
    if builtins.isAttrs x then mapAttrs (name: substFunction) x
    else if builtins.isList x then map substFunction x
    else if builtins.isFunction x then "<function>"
    else x;

  # Clean up declaration sites to not refer to the NixOS source tree.
  optionsList' = flip map optionsList (opt: opt // {
    declarations = map stripAnyPrefixes opt.declarations;
  }
  // optionalAttrs (opt ? example) { example = substFunction opt.example; }
  // optionalAttrs (opt ? default) { default = substFunction opt.default; }
  // optionalAttrs (opt ? type) { type = substFunction opt.type; });

  # We need to strip references to /nix/store/* from options,
  # including any `extraSources` if some modules came from elsewhere,
  # or else the build will fail.
  #
  # E.g. if some `options` came from modules in ${pkgs.customModules}/nix,
  # you'd need to include `extraSources = [ pkgs.customModules ]`
  prefixesToStrip = map (p: "${toString p}/") ([ ../../.. ] ++ extraSources);
  stripAnyPrefixes = flip (fold removePrefix) prefixesToStrip;

  # Convert the list of options into an XML file.
  optionsXML = builtins.toFile "options.xml" (builtins.toXML optionsList');

  optionsDocBook = runCommand "options-db.xml" {} ''
    optionsXML=${optionsXML}
    if grep /nixpkgs/nixos/modules $optionsXML; then
      echo "The manual appears to depend on the location of Nixpkgs, which is bad"
      echo "since this prevents sharing via the NixOS channel.  This is typically"
      echo "caused by an option default that refers to a relative path (see above"
      echo "for hints about the offending path)."
      exit 1
    fi
    ${libxslt}/bin/xsltproc \
      --stringparam revision '${revision}' \
      -o $out ${./options-to-docbook.xsl} $optionsXML
  '';

  sources = sourceFilesBySuffices ./. [".xml"];

  copySources =
    ''
      cp -prd $sources/* . # */
      chmod -R u+w .
      cp ${../../modules/services/databases/postgresql.xml} configuration/postgresql.xml
      cp ${../../modules/services/misc/gitlab.xml} configuration/gitlab.xml
      cp ${../../modules/security/acme.xml} configuration/acme.xml
      ln -s ${optionsDocBook} options-db.xml
      echo "${version}" > version
    '';

  toc = builtins.toFile "toc.xml"
    ''
      <toc role="chunk-toc">
        <d:tocentry xmlns:d="http://docbook.org/ns/docbook" linkend="book-nixos-manual"><?dbhtml filename="index.html"?>
          <d:tocentry linkend="ch-options"><?dbhtml filename="options.html"?></d:tocentry>
          <d:tocentry linkend="ch-release-notes"><?dbhtml filename="release-notes.html"?></d:tocentry>
        </d:tocentry>
      </toc>
    '';

in rec {

  # The NixOS options in JSON format.
  optionsJSON = stdenv.mkDerivation {
    name = "options-json";

    buildCommand = ''
      # Export list of options in different format.
      dst=$out/share/doc/nixos
      mkdir -p $dst

      cp ${builtins.toFile "options.json" (builtins.unsafeDiscardStringContext (builtins.toJSON
        (listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) optionsList'))))
      } $dst/options.json

      mkdir -p $out/nix-support
      echo "file json $dst/options.json" >> $out/nix-support/hydra-build-products
    ''; # */

    meta.description = "List of NixOS options in JSON format";
  };

  # Generate the NixOS manual.
  manual = stdenv.mkDerivation {
    name = "nixos-manual";

    inherit sources;

    buildInputs = [ libxml2 libxslt ];

    buildCommand = ''
      ${copySources}

      # Check the validity of the manual sources.
      xmllint --noout --nonet --xinclude --noxincludenode \
        --relaxng ${docbook5}/xml/rng/docbook/docbook.rng \
        manual.xml

      # Generate the HTML manual.
      dst=$out/share/doc/nixos
      mkdir -p $dst
      xsltproc \
        --param section.autolabel 1 \
        --param section.label.includes.component.label 1 \
        --stringparam html.stylesheet style.css \
        --param xref.with.number.and.title 1 \
        --param toc.section.depth 3 \
        --stringparam admon.style "" \
        --stringparam callout.graphics.extension .gif \
        --param chunk.section.depth 0 \
        --param chunk.first.sections 1 \
        --param use.id.as.filename 1 \
        --stringparam generate.toc "book toc appendix toc" \
        --stringparam chunk.toc ${toc} \
        --nonet --xinclude --output $dst/ \
        ${docbook5_xsl}/xml/xsl/docbook/xhtml/chunktoc.xsl ./manual.xml

      mkdir -p $dst/images/callouts
      cp ${docbook5_xsl}/xml/xsl/docbook/images/callouts/*.gif $dst/images/callouts/

      cp ${./style.css} $dst/style.css

      mkdir -p $out/nix-support
      echo "nix-build out $out" >> $out/nix-support/hydra-build-products
      echo "doc manual $dst" >> $out/nix-support/hydra-build-products
    ''; # */

    meta.description = "The NixOS manual in HTML format";

    allowedReferences = ["out"];
  };

  manualPDF = stdenv.mkDerivation {
    name = "nixos-manual-pdf";

    inherit sources;

    buildInputs = [ libxml2 libxslt dblatex dblatex.tex ];

    buildCommand = ''
      ${copySources}

      dst=$out/share/doc/nixos
      mkdir -p $dst
      xmllint --xinclude manual.xml | dblatex -o $dst/manual.pdf - \
        -P doc.collab.show=0 \
        -P latex.output.revhistory=0

      mkdir -p $out/nix-support
      echo "doc-pdf manual $dst/manual.pdf" >> $out/nix-support/hydra-build-products
    '';
  };

  # Generate the NixOS manpages.
  manpages = stdenv.mkDerivation {
    name = "nixos-manpages";

    inherit sources;

    buildInputs = [ libxml2 libxslt ];

    buildCommand = ''
      ${copySources}

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
        --param man.break.after.slash 1 \
        ${docbook5_xsl}/xml/xsl/docbook/manpages/docbook.xsl \
        ./man-pages.xml
    '';

    allowedReferences = ["out"];
  };

}
