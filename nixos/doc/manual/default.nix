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
      printf "%s" "${version}" > version
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

  manual-combined = runCommand "nixos-manual-combined"
    { inherit sources;
      buildInputs = [ libxml2 libxslt ];
      meta.description = "The NixOS manual as plain docbook XML";
    }
    ''
      ${copySources}

      xmllint --xinclude --output ./manual-combined.xml ./manual.xml
      xmllint --xinclude --noxincludenode \
         --output ./man-pages-combined.xml ./man-pages.xml

      # outputs the context of an xmllint error output
      # LEN lines around the failing line are printed
      function context {
        # length of context
        local LEN=6
        # lines to print before error line
        local BEFORE=4

        # xmllint output lines are:
        # file.xml:1234: there was an error on line 1234
        while IFS=':' read -r file line rest; do
          echo
          if [[ -n "$rest" ]]; then
            echo "$file:$line:$rest"
            local FROM=$(($line>$BEFORE ? $line - $BEFORE : 1))
            # number lines & filter context
            nl --body-numbering=a "$file" | sed -n "$FROM,+$LEN p"
          else
            if [[ -n "$line" ]]; then
              echo "$file:$line"
            else
              echo "$file"
            fi
          fi
        done
      }

      function lintrng {
        xmllint --debug --noout --nonet \
          --relaxng ${docbook5}/xml/rng/docbook/docbook.rng \
          "$1" \
          2>&1 | context 1>&2
          # ^ redirect assumes xmllint doesn’t print to stdout
      }

      lintrng manual-combined.xml
      lintrng man-pages-combined.xml

      mkdir $out
      cp manual-combined.xml $out/
      cp man-pages-combined.xml $out/
    '';

  olinkDB = runCommand "manual-olinkdb"
    { inherit sources;
      buildInputs = [ libxml2 libxslt ];
    }
    ''
      xsltproc \
        ${manualXsltprocOptions} \
        --stringparam collect.xref.targets only \
        --stringparam targets.filename "$out/manual.db" \
        --nonet \
        ${docbook5_xsl}/xml/xsl/docbook/xhtml/chunktoc.xsl \
        ${manual-combined}/manual-combined.xml

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

in rec {

  # The NixOS options in JSON format.
  optionsJSON = runCommand "options-json"
    { meta.description = "List of NixOS options in JSON format";
    }
    ''
      # Export list of options in different format.
      dst=$out/share/doc/nixos
      mkdir -p $dst

      cp ${builtins.toFile "options.json" (builtins.unsafeDiscardStringContext (builtins.toJSON
        (builtins.listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) optionsList'))))
      } $dst/options.json

      mkdir -p $out/nix-support
      echo "file json $dst/options.json" >> $out/nix-support/hydra-build-products
    ''; # */

  # Generate the NixOS manual.
  manual = runCommand "nixos-manual"
    { inherit sources;
      buildInputs = [ libxml2 libxslt ];
      meta.description = "The NixOS manual in HTML format";
      allowedReferences = ["out"];
    }
    ''
      # Generate the HTML manual.
      dst=$out/share/doc/nixos
      mkdir -p $dst
      xsltproc \
        ${manualXsltprocOptions} \
        --stringparam target.database.document "${olinkDB}/olinkdb.xml" \
        --nonet --output $dst/ \
        ${docbook5_xsl}/xml/xsl/docbook/xhtml/chunktoc.xsl \
        ${manual-combined}/manual-combined.xml

      mkdir -p $dst/images/callouts
      cp ${docbook5_xsl}/xml/xsl/docbook/images/callouts/*.gif $dst/images/callouts/

      cp ${./style.css} $dst/style.css

      mkdir -p $out/nix-support
      echo "nix-build out $out" >> $out/nix-support/hydra-build-products
      echo "doc manual $dst" >> $out/nix-support/hydra-build-products
    ''; # */


  manualEpub = runCommand "nixos-manual-epub"
    { inherit sources;
      buildInputs = [ libxml2 libxslt zip ];
    }
    ''
      # Generate the epub manual.
      dst=$out/share/doc/nixos

      xsltproc \
        ${manualXsltprocOptions} \
        --stringparam target.database.document "${olinkDB}/olinkdb.xml" \
        --nonet --xinclude --output $dst/epub/ \
        ${docbook5_xsl}/xml/xsl/docbook/epub/docbook.xsl \
        ${manual-combined}/manual-combined.xml

      mkdir -p $dst/epub/OEBPS/images/callouts
      cp -r ${docbook5_xsl}/xml/xsl/docbook/images/callouts/*.gif $dst/epub/OEBPS/images/callouts # */
      echo "application/epub+zip" > mimetype
      manual="$dst/nixos-manual.epub"
      zip -0Xq "$manual" mimetype
      cd $dst/epub && zip -Xr9D "$manual" *

      rm -rf $dst/epub

      mkdir -p $out/nix-support
      echo "doc-epub manual $manual" >> $out/nix-support/hydra-build-products
    '';


  # Generate the NixOS manpages.
  manpages = runCommand "nixos-manpages"
    { inherit sources;
      buildInputs = [ libxml2 libxslt ];
      allowedReferences = ["out"];
    }
    ''
      # Generate manpages.
      mkdir -p $out/share/man
      xsltproc --nonet \
        --param man.output.in.separate.dir 1 \
        --param man.output.base.dir "'$out/share/man/'" \
        --param man.endnotes.are.numbered 0 \
        --param man.break.after.slash 1 \
        --stringparam target.database.document "${olinkDB}/olinkdb.xml" \
        ${docbook5_xsl}/xml/xsl/docbook/manpages/docbook.xsl \
        ${manual-combined}/man-pages-combined.xml
    '';

}
