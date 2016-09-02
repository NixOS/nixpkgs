{ pkgs, options, config, version, revision, extraSources ? [] }:

with pkgs;

let
  lib = pkgs.lib;

  # Remove invisible and internal options.
  optionsList = lib.filter (opt: opt.visible && !opt.internal) (lib.optionAttrSetToDocList options);

  # Replace functions by the string <function>
  substFunction = x:
    if builtins.isAttrs x then lib.mapAttrs (name: substFunction) x
    else if builtins.isList x then map substFunction x
    else if builtins.isFunction x then "<function>"
    else x;

  # Clean up declaration sites to not refer to the NixOS source tree.
  optionsList' = lib.flip map optionsList (opt: opt // {
    declarations = map stripAnyPrefixes opt.declarations;
  }
  // lib.optionalAttrs (opt ? example) { example = substFunction opt.example; }
  // lib.optionalAttrs (opt ? default) { default = substFunction opt.default; }
  // lib.optionalAttrs (opt ? type) { type = substFunction opt.type; });

  # We need to strip references to /nix/store/* from options,
  # including any `extraSources` if some modules came from elsewhere,
  # or else the build will fail.
  #
  # E.g. if some `options` came from modules in ${pkgs.customModules}/nix,
  # you'd need to include `extraSources = [ pkgs.customModules ]`
  prefixesToStrip = map (p: "${toString p}/") ([ ../../.. ] ++ extraSources);
  stripAnyPrefixes = lib.flip (lib.fold lib.removePrefix) prefixesToStrip;

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
    ${libxslt.bin}/bin/xsltproc \
      --stringparam revision '${revision}' \
      -o $out ${./options-to-docbook.xsl} $optionsXML
  '';

  sources = lib.sourceFilesBySuffices ./. [".xml"];

  modulesDoc = builtins.toFile "modules.xml" ''
    <section xmlns:xi="http://www.w3.org/2001/XInclude" id="modules">
    ${(lib.concatMapStrings (path: ''
      <xi:include href="${path}" />
    '') (lib.catAttrs "value" config.meta.doc))}
    </section>
  '';

  copySources =
    ''
      cp -prd $sources/* . # */
      chmod -R u+w .
      ln -s ${modulesDoc} configuration/modules.xml
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

  manualXsltprocOptions = toString [
    "--param section.autolabel 1"
    "--param section.label.includes.component.label 1"
    "--stringparam html.stylesheet style.css"
    "--param xref.with.number.and.title 1"
    "--param toc.section.depth 3"
    "--stringparam admon.style ''"
    "--stringparam callout.graphics.extension .gif"
    "--stringparam current.docid manual"
    "--param chunk.section.depth 0"
    "--param chunk.first.sections 1"
    "--param use.id.as.filename 1"
    "--stringparam generate.toc 'book toc appendix toc'"
    "--stringparam chunk.toc ${toc}"
  ];

  olinkDB = stdenv.mkDerivation {
    name = "manual-olinkdb";

    inherit sources;

    buildInputs = [ libxml2 libxslt ];

    buildCommand = ''
      ${copySources}

      xsltproc \
        ${manualXsltprocOptions} \
        --stringparam collect.xref.targets only \
        --stringparam targets.filename "$out/manual.db" \
        --nonet --xinclude \
        ${docbook5_xsl}/xml/xsl/docbook/xhtml/chunktoc.xsl \
        ./manual.xml

      # Check the validity of the man pages sources.
      xmllint --noout --nonet --xinclude --noxincludenode \
        --relaxng ${docbook5}/xml/rng/docbook/docbook.rng \
        ./man-pages.xml

      cat > "$out/olinkdb.xml" <<EOF
      <?xml version="1.0" encoding="utf-8"?>
      <!DOCTYPE targetset SYSTEM
        "file://${docbook5_xsl}/xml/xsl/docbook/common/targetdatabase.dtd" [
        <!ENTITY manualtargets SYSTEM "file://$out/manual.db">
      ]>
      <targetset>
        <targetsetinfo>
            Allows for cross-referencing olinks between the manpages
            and manual.
        </targetsetinfo>

        <document targetdoc="manual">&manualtargets;</document>
      </targetset>
      EOF
    '';
  };

in rec {

  # The NixOS options in JSON format.
  optionsJSON = stdenv.mkDerivation {
    name = "options-json";

    buildCommand = ''
      # Export list of options in different format.
      dst=$out/share/doc/nixos
      mkdir -p $dst

      cp ${builtins.toFile "options.json" (builtins.unsafeDiscardStringContext (builtins.toJSON
        (builtins.listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) optionsList'))))
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
        ${manualXsltprocOptions} \
        --stringparam target.database.document "${olinkDB}/olinkdb.xml" \
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


  manualEpub = stdenv.mkDerivation {
    name = "nixos-manual-epub";

    inherit sources;

    buildInputs = [ libxml2 libxslt zip ];

    buildCommand = ''
      ${copySources}

      # Check the validity of the manual sources.
      xmllint --noout --nonet --xinclude --noxincludenode \
        --relaxng ${docbook5}/xml/rng/docbook/docbook.rng \
        manual.xml

      # Generate the epub manual.
      dst=$out/share/doc/nixos

      xsltproc \
        ${manualXsltprocOptions} \
        --stringparam target.database.document "${olinkDB}/olinkdb.xml" \
        --nonet --xinclude --output $dst/epub/ \
        ${docbook5_xsl}/xml/xsl/docbook/epub/docbook.xsl ./manual.xml

      mkdir -p $dst/epub/OEBPS/images/callouts
      cp -r ${docbook5_xsl}/xml/xsl/docbook/images/callouts/*.gif $dst/epub/OEBPS/images/callouts
      echo "application/epub+zip" > mimetype
      manual="$dst/nixos-manual.epub"
      zip -0Xq "$manual" mimetype
      cd $dst/epub && zip -Xr9D "$manual" *

      rm -rf $dst/epub

      mkdir -p $out/nix-support
      echo "doc-epub manual $manual" >> $out/nix-support/hydra-build-products
    '';
  };

  # Generate the NixOS manpages.
  manpages = stdenv.mkDerivation {
    name = "nixos-manpages";

    inherit sources;

    buildInputs = [ libxml2 libxslt ];

    buildCommand = ''
      ${copySources}

      # Check the validity of the man pages sources.
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
        --stringparam target.database.document "${olinkDB}/olinkdb.xml" \
        ${docbook5_xsl}/xml/xsl/docbook/manpages/docbook.xsl \
        ./man-pages.xml
    '';

    allowedReferences = ["out"];
  };

}
