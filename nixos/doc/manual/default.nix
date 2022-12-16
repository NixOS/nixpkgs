{ pkgs
, options
, config
, version
, revision
, extraSources ? []
, baseOptionsJSON ? null
, warningsAreErrors ? true
, allowDocBook ? true
, prefix ? ../../..
}:

with pkgs;

let
  inherit (lib) hasPrefix removePrefix;

  lib = pkgs.lib;

  docbook_xsl_ns = pkgs.docbook-xsl-ns.override {
    withManOptDedupPatch = true;
  };

  # We need to strip references to /nix/store/* from options,
  # including any `extraSources` if some modules came from elsewhere,
  # or else the build will fail.
  #
  # E.g. if some `options` came from modules in ${pkgs.customModules}/nix,
  # you'd need to include `extraSources = [ pkgs.customModules ]`
  prefixesToStrip = map (p: "${toString p}/") ([ prefix ] ++ extraSources);
  stripAnyPrefixes = lib.flip (lib.foldr lib.removePrefix) prefixesToStrip;

  optionsDoc = buildPackages.nixosOptionsDoc {
    inherit options revision baseOptionsJSON warningsAreErrors allowDocBook;
    transformOptions = opt: opt // {
      # Clean up declaration sites to not refer to the NixOS source tree.
      declarations = map stripAnyPrefixes opt.declarations;
    };
  };

  nixos-lib = import ../../lib { };

  testOptionsDoc = let
      eval = nixos-lib.evalTest {
        # Avoid evaluating a NixOS config prototype.
        config.node.type = lib.types.deferredModule;
        options._module.args = lib.mkOption { internal = true; };
      };
    in buildPackages.nixosOptionsDoc {
      inherit (eval) options;
      inherit (revision);
      transformOptions = opt: opt // {
        # Clean up declaration sites to not refer to the NixOS source tree.
        declarations =
          map
            (decl:
              if hasPrefix (toString ../../..) (toString decl)
              then
                let subpath = removePrefix "/" (removePrefix (toString ../../..) (toString decl));
                in { url = "https://github.com/NixOS/nixpkgs/blob/master/${subpath}"; name = subpath; }
              else decl)
            opt.declarations;
      };
      documentType = "none";
      variablelistId = "test-options-list";
      optionIdPrefix = "test-opt-";
    };

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
    ln -s ${optionsDoc.optionsDocBook} $out/options-db.xml
    ln -s ${testOptionsDoc.optionsDocBook} $out/test-options-db.xml
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
    "--param chapter.autolabel 0"
    "--param part.autolabel 0"
    "--param preface.autolabel 0"
    "--param reference.autolabel 0"
    "--param section.autolabel 0"
    "--stringparam html.stylesheet 'style.css overrides.css highlightjs/mono-blue.css'"
    "--stringparam html.script './highlightjs/highlight.pack.js ./highlightjs/loader.js'"
    "--param xref.with.number.and.title 0"
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

      mkdir $out
      cp manual-combined.xml $out/
      cp man-pages-combined.xml $out/

      lintrng $out/manual-combined.xml
      lintrng $out/man-pages-combined.xml
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

  inherit (optionsDoc) optionsJSON optionsNix optionsDocBook;

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
        ${manual-combined}/manual-combined.xml \
        |& tee xsltproc.out
      grep "^ID recommended on" xsltproc.out &>/dev/null && echo "error: some IDs are missing" && false
      rm xsltproc.out

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
      nativeBuildInputs = [ buildPackages.libxml2.bin buildPackages.libxslt.bin buildPackages.zip ];
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
        --maxdepth 6000 \
        --param man.output.in.separate.dir 1 \
        --param man.output.base.dir "'$out/share/man/'" \
        --param man.endnotes.are.numbered 0 \
        --param man.break.after.slash 1 \
        --stringparam target.database.document "${olinkDB}/olinkdb.xml" \
        ${docbook_xsl_ns}/xml/xsl/docbook/manpages/docbook.xsl \
        ${manual-combined}/man-pages-combined.xml
    '';

}
