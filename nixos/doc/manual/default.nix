{ pkgs, options, config, version, revision, extraSources ? [] }:

with pkgs;

let
  lib = pkgs.lib;

  # Remove invisible and internal options.
  optionsListVisible = lib.filter (opt: opt.visible && !opt.internal) (lib.optionAttrSetToDocList options);

  # Replace functions by the string <function>
  substFunction = x:
    if builtins.isAttrs x then lib.mapAttrs (name: substFunction) x
    else if builtins.isList x then map substFunction x
    else if lib.isFunction x then "<function>"
    else x;

  # Generate DocBook documentation for a list of packages. This is
  # what `relatedPackages` option of `mkOption` from
  # ../../../lib/options.nix influences.
  #
  # Each element of `relatedPackages` can be either
  # - a string:  that will be interpreted as an attribute name from `pkgs`,
  # - a list:    that will be interpreted as an attribute path from `pkgs`,
  # - an attrset: that can specify `name`, `path`, `package`, `comment`
  #   (either of `name`, `path` is required, the rest are optional).
  genRelatedPackages = packages:
    let
      unpack = p: if lib.isString p then { name = p; }
                  else if lib.isList p then { path = p; }
                  else p;
      describe = args:
        let
          title = args.title or null;
          name = args.name or (lib.concatStringsSep "." args.path);
          path = args.path or [ args.name ];
          package = args.package or (lib.attrByPath path (throw "Invalid package attribute path `${toString path}'") pkgs);
        in "<listitem>"
        + "<para><literal>${lib.optionalString (title != null) "${title} aka "}pkgs.${name} (${package.meta.name})</literal>"
        + lib.optionalString (!package.meta.available) " <emphasis>[UNAVAILABLE]</emphasis>"
        + ": ${package.meta.description or "???"}.</para>"
        + lib.optionalString (args ? comment) "\n<para>${args.comment}</para>"
        # Lots of `longDescription's break DocBook, so we just wrap them into <programlisting>
        + lib.optionalString (package.meta ? longDescription) "\n<programlisting>${package.meta.longDescription}</programlisting>"
        + "</listitem>";
    in "<itemizedlist>${lib.concatStringsSep "\n" (map (p: describe (unpack p)) packages)}</itemizedlist>";

  optionsListDesc = lib.flip map optionsListVisible (opt: opt // {
    # Clean up declaration sites to not refer to the NixOS source tree.
    declarations = map stripAnyPrefixes opt.declarations;
  }
  // lib.optionalAttrs (opt ? example) { example = substFunction opt.example; }
  // lib.optionalAttrs (opt ? default) { default = substFunction opt.default; }
  // lib.optionalAttrs (opt ? type) { type = substFunction opt.type; }
  // lib.optionalAttrs (opt ? relatedPackages && opt.relatedPackages != []) { relatedPackages = genRelatedPackages opt.relatedPackages; });

  # We need to strip references to /nix/store/* from options,
  # including any `extraSources` if some modules came from elsewhere,
  # or else the build will fail.
  #
  # E.g. if some `options` came from modules in ${pkgs.customModules}/nix,
  # you'd need to include `extraSources = [ pkgs.customModules ]`
  prefixesToStrip = map (p: "${toString p}/") ([ ../../.. ] ++ extraSources);
  stripAnyPrefixes = lib.flip (lib.fold lib.removePrefix) prefixesToStrip;

  # Custom "less" that pushes up all the things ending in ".enable*"
  # and ".package*"
  optionLess = a: b:
    let
      ise = lib.hasPrefix "enable";
      isp = lib.hasPrefix "package";
      cmp = lib.splitByAndCompare ise lib.compare
                                 (lib.splitByAndCompare isp lib.compare lib.compare);
    in lib.compareLists cmp a.loc b.loc < 0;

  # Customly sort option list for the man page.
  optionsList = lib.sort optionLess optionsListDesc;

  # Convert the list of options into an XML file.
  optionsXML = builtins.toFile "options.xml" (builtins.toXML optionsList);

  optionsDocBook = runCommand "options-db.xml" {} ''
    optionsXML=${optionsXML}
    if grep /nixpkgs/nixos/modules $optionsXML; then
      echo "The manual appears to depend on the location of Nixpkgs, which is bad"
      echo "since this prevents sharing via the NixOS channel.  This is typically"
      echo "caused by an option default that refers to a relative path (see above"
      echo "for hints about the offending path)."
      exit 1
    fi
    ${buildPackages.libxslt.bin}/bin/xsltproc \
      --stringparam revision '${revision}' \
      -o intermediate.xml ${./options-to-docbook.xsl} $optionsXML
    ${buildPackages.libxslt.bin}/bin/xsltproc \
      -o "$out" ${./postprocess-option-descriptions.xsl} intermediate.xml
  '';

  sources = lib.sourceFilesBySuffices ./. [".xml"];

  modulesDoc = builtins.toFile "modules.xml" ''
    <section xmlns:xi="http://www.w3.org/2001/XInclude" id="modules">
    ${(lib.concatMapStrings (path: ''
      <xi:include href="${path}" />
    '') (lib.catAttrs "value" config.meta.doc))}
    </section>
  '';

  generatedSources = runCommand "generated-docbook" {} ''
    mkdir $out
    ln -s ${modulesDoc} $out/modules.xml
    ln -s ${optionsDocBook} $out/options-db.xml
    printf "%s" "${version}" > $out/version
  '';

  copySources =
    ''
      cp -prd $sources/* . # */
      ln -s ${generatedSources} ./generated
      chmod -R u+w .
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
    "--stringparam html.stylesheet 'style.css overrides.css highlightjs/mono-blue.css'"
    "--stringparam html.script './highlightjs/highlight.pack.js ./highlightjs/loader.js'"
    "--param xref.with.number.and.title 1"
    "--param toc.section.depth 3"
    "--stringparam admon.style ''"
    "--stringparam callout.graphics.extension .svg"
    "--stringparam current.docid manual"
    "--param chunk.section.depth 0"
    "--param chunk.first.sections 1"
    "--param use.id.as.filename 1"
    "--stringparam generate.toc 'book toc appendix toc'"
    "--stringparam chunk.toc ${toc}"
  ];

  manual-combined = runCommand "nixos-manual-combined"
    { inherit sources;
      nativeBuildInputs = [ buildPackages.libxml2.bin buildPackages.libxslt.bin ];
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
      nativeBuildInputs = [ buildPackages.libxml2.bin buildPackages.libxslt.bin ];
    }
    ''
      xsltproc \
        ${manualXsltprocOptions} \
        --stringparam collect.xref.targets only \
        --stringparam targets.filename "$out/manual.db" \
        --nonet \
        ${docbook_xsl_ns}/xml/xsl/docbook/xhtml/chunktoc.xsl \
        ${manual-combined}/manual-combined.xml

      cat > "$out/olinkdb.xml" <<EOF
      <?xml version="1.0" encoding="utf-8"?>
      <!DOCTYPE targetset SYSTEM
        "file://${docbook_xsl_ns}/xml/xsl/docbook/common/targetdatabase.dtd" [
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
  inherit generatedSources;

  # The NixOS options in JSON format.
  optionsJSON = runCommand "options-json"
    { meta.description = "List of NixOS options in JSON format";
    }
    ''
      # Export list of options in different format.
      dst=$out/share/doc/nixos
      mkdir -p $dst

      cp ${builtins.toFile "options.json" (builtins.unsafeDiscardStringContext (builtins.toJSON
        (builtins.listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) optionsList))))
      } $dst/options.json

      mkdir -p $out/nix-support
      echo "file json $dst/options.json" >> $out/nix-support/hydra-build-products
    ''; # */

  # Generate the NixOS manual.
  manualHTML = runCommand "nixos-manual-html"
    { inherit sources;
      nativeBuildInputs = [ buildPackages.libxml2.bin buildPackages.libxslt.bin ];
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
        --stringparam id.warnings "1" \
        --nonet --output $dst/ \
        ${docbook_xsl_ns}/xml/xsl/docbook/xhtml/chunktoc.xsl \
        ${manual-combined}/manual-combined.xml

      mkdir -p $dst/images/callouts
      cp ${docbook_xsl_ns}/xml/xsl/docbook/images/callouts/*.svg $dst/images/callouts/

      cp ${../../../doc/style.css} $dst/style.css
      cp ${../../../doc/overrides.css} $dst/overrides.css
      cp -r ${pkgs.documentation-highlighter} $dst/highlightjs

      mkdir -p $out/nix-support
      echo "nix-build out $out" >> $out/nix-support/hydra-build-products
      echo "doc manual $dst" >> $out/nix-support/hydra-build-products
    ''; # */

  # Alias for backward compatibility. TODO(@oxij): remove eventually.
  manual = manualHTML;

  # Index page of the NixOS manual.
  manualHTMLIndex = "${manualHTML}/share/doc/nixos/index.html";

  manualEpub = runCommand "nixos-manual-epub"
    { inherit sources;
      buildInputs = [ libxml2.bin libxslt.bin zip ];
    }
    ''
      # Generate the epub manual.
      dst=$out/share/doc/nixos

      xsltproc \
        ${manualXsltprocOptions} \
        --stringparam target.database.document "${olinkDB}/olinkdb.xml" \
        --nonet --xinclude --output $dst/epub/ \
        ${docbook_xsl_ns}/xml/xsl/docbook/epub/docbook.xsl \
        ${manual-combined}/manual-combined.xml

      mkdir -p $dst/epub/OEBPS/images/callouts
      cp -r ${docbook_xsl_ns}/xml/xsl/docbook/images/callouts/*.svg $dst/epub/OEBPS/images/callouts # */
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
      nativeBuildInputs = [ buildPackages.libxml2.bin buildPackages.libxslt.bin ];
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
        ${docbook_xsl_ns}/xml/xsl/docbook/manpages/docbook.xsl \
        ${manual-combined}/man-pages-combined.xml
    '';

}
