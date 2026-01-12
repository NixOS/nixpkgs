{
  pkgs,
  options,
  config,
  version,
  revision,
  extraSources ? [ ],
  baseOptionsJSON ? null,
  warningsAreErrors ? true,
  prefix ? ../../..,
  checkRedirects ? true,
}:

let
  inherit (pkgs) buildPackages runCommand docbook_xsl_ns;

  inherit (pkgs.lib)
    evalModules
    hasPrefix
    removePrefix
    flip
    foldr
    types
    mkOption
    escapeShellArg
    concatMapStringsSep
    sourceFilesBySuffices
    modules
    ;

  common = import ./common.nix;

  manpageUrls = pkgs.path + "/doc/manpage-urls.json";

  # We need to strip references to /nix/store/* from options,
  # including any `extraSources` if some modules came from elsewhere,
  # or else the build will fail.
  #
  # E.g. if some `options` came from modules in ${pkgs.customModules}/nix,
  # you'd need to include `extraSources = [ pkgs.customModules ]`
  prefixesToStrip = map (p: "${toString p}/") ([ prefix ] ++ extraSources);
  stripAnyPrefixes = flip (foldr removePrefix) prefixesToStrip;

  optionsDoc = buildPackages.nixosOptionsDoc {
    inherit
      options
      revision
      baseOptionsJSON
      warningsAreErrors
      ;
    transformOptions =
      opt:
      opt
      // {
        # Clean up declaration sites to not refer to the NixOS source tree.
        declarations = map stripAnyPrefixes opt.declarations;
      };
  };

  nixos-lib = import ../../lib { };

  testOptionsDoc =
    let
      eval = nixos-lib.evalTest {
        # Avoid evaluating a NixOS config prototype.
        config.node.type = types.deferredModule;
        options._module.args = mkOption { internal = true; };
      };
    in
    buildPackages.nixosOptionsDoc {
      inherit (eval) options;
      inherit revision;
      transformOptions =
        opt:
        opt
        // {
          # Clean up declaration sites to not refer to the NixOS source tree.
          declarations = map (
            decl:
            if hasPrefix (toString ../../..) (toString decl) then
              let
                subpath = removePrefix "/" (removePrefix (toString ../../..) (toString decl));
              in
              {
                url = "https://github.com/NixOS/nixpkgs/blob/master/${subpath}";
                name = subpath;
              }
            else
              decl
          ) opt.declarations;
        };
      documentType = "none";
      variablelistId = "test-options-list";
      optionIdPrefix = "test-opt-";
    };

  testDriverMachineDocstrings =
    pkgs.callPackage ../../../nixos/lib/test-driver/nixos-test-driver-docstrings.nix
      { };

  prepareManualFromMD = ''
    cp -r --no-preserve=all $inputs/* .

    cp -r ${../../../doc/release-notes} ./release-notes-nixpkgs

    substituteInPlace ./manual.md \
      --replace-fail '@NIXOS_VERSION@' "${version}"
    substituteInPlace ./configuration/configuration.md \
      --replace-fail \
          '@MODULE_CHAPTERS@' \
          ${escapeShellArg (concatMapStringsSep "\n" (p: "${p.value}") config.meta.doc)}
    substituteInPlace ./nixos-options.md \
      --replace-fail \
        '@NIXOS_OPTIONS_JSON@' \
        ${optionsDoc.optionsJSON}/${common.outputPath}/options.json
    substituteInPlace ./development/writing-nixos-tests.section.md \
      --replace-fail \
        '@NIXOS_TEST_OPTIONS_JSON@' \
        ${testOptionsDoc.optionsJSON}/${common.outputPath}/options.json
    sed -e '/@PYTHON_MACHINE_METHODS@/ {' -e 'r ${testDriverMachineDocstrings}/machine-methods.md' -e 'd' -e '}' \
      -i ./development/writing-nixos-tests.section.md
    substituteInPlace ./development/modular-services.md \
      --replace-fail \
        '@PORTABLE_SERVICE_OPTIONS@' \
        ${portableServiceOptions.optionsJSON}/${common.outputPath}/options.json
    substituteInPlace ./development/modular-services.md \
      --replace-fail \
        '@SYSTEMD_SERVICE_OPTIONS@' \
        ${systemdServiceOptions.optionsJSON}/${common.outputPath}/options.json
  '';

  portableServiceOptions = buildPackages.nixosOptionsDoc {
    inherit
      (evalModules {
        modules = [
          (modules.importApply ../../modules/system/service/portable/service.nix {
            pkgs = throw "nixos docs / portableServiceOptions: Do not reference pkgs in docs";
          })
        ];
      })
      options
      ;
    inherit revision warningsAreErrors;
    transformOptions =
      opt:
      opt
      // {
        # Clean up declaration sites to not refer to the NixOS source tree.
        declarations = map stripAnyPrefixes opt.declarations;
      };
  };

  systemdServiceOptions = buildPackages.nixosOptionsDoc {
    inherit (evalModules { modules = [ ../../modules/system/service/systemd/service.nix ]; }) options;
    # TODO: filter out options that are not systemd-specific, maybe also change option prefix to just `service-opt-`?
    inherit revision warningsAreErrors;
    transformOptions =
      opt:
      opt
      // {
        # Clean up declaration sites to not refer to the NixOS source tree.
        declarations = map stripAnyPrefixes opt.declarations;
      };
  };

in
rec {
  inherit (optionsDoc) optionsJSON optionsNix optionsDocBook;

  # Generate the NixOS manual.
  manualHTML =
    runCommand "nixos-manual-html"
      {
        nativeBuildInputs = [ buildPackages.nixos-render-docs ];
        inputs = sourceFilesBySuffices ./. [ ".md" ];
        meta.description = "The NixOS manual in HTML format";
        allowedReferences = [ "out" ];
      }
      ''
        # Generate the HTML manual.
        dst=$out/${common.outputPath}
        mkdir -p $dst

        cp ${../../../doc/style.css} $dst/style.css
        cp ${../../../doc/anchor.min.js} $dst/anchor.min.js
        cp ${../../../doc/anchor-use.js} $dst/anchor-use.js

        cp -r ${pkgs.documentation-highlighter} $dst/highlightjs

        ${prepareManualFromMD}

        nixos-render-docs -j $NIX_BUILD_CORES manual html \
          --manpage-urls ${manpageUrls} \
          ${if checkRedirects then "--redirects ${./redirects.json}" else ""} \
          --revision ${escapeShellArg revision} \
          --generator "nixos-render-docs ${pkgs.lib.version}" \
          --stylesheet style.css \
          --stylesheet highlightjs/mono-blue.css \
          --script ./highlightjs/highlight.pack.js \
          --script ./highlightjs/loader.js \
          --script ./anchor.min.js \
          --script ./anchor-use.js \
          --toc-depth 1 \
          --chunk-toc-depth 1 \
          ./manual.md \
          $dst/${common.indexPath}

        cp ${pkgs.roboto.src}/web/Roboto\[ital\,wdth\,wght\].ttf "$dst/Roboto.ttf"

        mkdir -p $out/nix-support
        echo "nix-build out $out" >> $out/nix-support/hydra-build-products
        echo "doc manual $dst" >> $out/nix-support/hydra-build-products
      ''; # */

  # Alias for backward compatibility. TODO(@oxij): remove eventually.
  manual = manualHTML;

  # Index page of the NixOS manual.
  manualHTMLIndex = "${manualHTML}/${common.outputPath}/${common.indexPath}";

  manualEpub =
    runCommand "nixos-manual-epub"
      {
        nativeBuildInputs = [
          buildPackages.libxml2.bin
          buildPackages.libxslt.bin
          buildPackages.zip
        ];
        doc = ''
          <book xmlns="http://docbook.org/ns/docbook"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                version="5.0"
                xml:id="book-nixos-manual">
            <info>
              <title>NixOS Manual</title>
              <subtitle>Version ${pkgs.lib.version}</subtitle>
            </info>
            <chapter>
              <title>Temporarily unavailable</title>
              <para>
                The NixOS manual is currently not available in EPUB format,
                please use the <link xlink:href="https://nixos.org/nixos/manual">HTML manual</link>
                instead.
              </para>
              <para>
                If you've used the EPUB manual in the past and it has been useful to you, please
                <link xlink:href="https://github.com/NixOS/nixpkgs/issues/237234">let us know</link>.
              </para>
            </chapter>
          </book>
        '';
        passAsFile = [ "doc" ];
      }
      ''
        # Generate the epub manual.
        dst=$out/${common.outputPath}

        xsltproc \
          --param chapter.autolabel 0 \
          --nonet --xinclude --output $dst/epub/ \
          ${docbook_xsl_ns}/xml/xsl/docbook/epub/docbook.xsl \
          $docPath

        echo "application/epub+zip" > mimetype
        manual="$dst/nixos-manual.epub"
        zip -0Xq "$manual" mimetype
        cd $dst/epub && zip -Xr9D "$manual" *

        rm -rf $dst/epub

        mkdir -p $out/nix-support
        echo "doc-epub manual $manual" >> $out/nix-support/hydra-build-products
      '';

  # Generate the `man configuration.nix` package
  nixos-configuration-reference-manpage =
    runCommand "nixos-configuration-reference-manpage"
      {
        nativeBuildInputs = [
          buildPackages.installShellFiles
          buildPackages.nixos-render-docs
        ];
        allowedReferences = [ "out" ];
      }
      ''
        # Generate manpages.
        mkdir -p $out/share/man/man5
        nixos-render-docs -j $NIX_BUILD_CORES options manpage \
          --revision ${escapeShellArg revision} \
          ${optionsJSON}/${common.outputPath}/options.json \
          $out/share/man/man5/configuration.nix.5
        compressManPages $out
      '';

}
