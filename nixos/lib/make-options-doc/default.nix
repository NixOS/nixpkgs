/* Generate JSON, XML and DocBook documentation for given NixOS options.

   Minimal example:

    { pkgs,  }:

    let
      eval = import (pkgs.path + "/nixos/lib/eval-config.nix") {
        baseModules = [
          ../module.nix
        ];
        modules = [];
      };
    in pkgs.nixosOptionsDoc {
      options = eval.options;
    }

*/
{ pkgs
, lib
, options
, transformOptions ? lib.id  # function for additional transformations of the options
, documentType ? "appendix" # TODO deprecate "appendix" in favor of "none"
                            #      and/or rename function to moduleOptionDoc for clean slate

  # If you include more than one option list into a document, you need to
  # provide different ids.
, variablelistId ? "configuration-variable-list"
  # String to prefix to the option XML/HTML id attributes.
, optionIdPrefix ? "opt-"
, revision ? "" # Specify revision for the options
# a set of options the docs we are generating will be merged into, as if by recursiveUpdate.
# used to split the options doc build into a static part (nixos/modules) and a dynamic part
# (non-nixos modules imported via configuration.nix, other module sources).
, baseOptionsJSON ? null
# instead of printing warnings for eg options with missing descriptions (which may be lost
# by nix build unless -L is given), emit errors instead and fail the build
, warningsAreErrors ? true
# allow docbook option docs if `true`. only markdown documentation is allowed when set to
# `false`, and a different renderer may be used with different bugs and performance
# characteristics but (hopefully) indistinguishable output.
, allowDocBook ? true
# whether lib.mdDoc is required for descriptions to be read as markdown.
# !!! when this is eventually flipped to true, `lib.doRename` should also default to emitting Markdown
, markdownByDefault ? false
}:

let
  rawOpts = lib.optionAttrSetToDocList options;
  transformedOpts = map transformOptions rawOpts;
  filteredOpts = lib.filter (opt: opt.visible && !opt.internal) transformedOpts;
  optionsList = lib.flip map filteredOpts
   (opt: opt
    // lib.optionalAttrs (opt ? relatedPackages && opt.relatedPackages != []) { relatedPackages = genRelatedPackages opt.relatedPackages opt.name; }
   );

  # Generate DocBook documentation for a list of packages. This is
  # what `relatedPackages` option of `mkOption` from
  # ../../../lib/options.nix influences.
  #
  # Each element of `relatedPackages` can be either
  # - a string:  that will be interpreted as an attribute name from `pkgs` and turned into a link
  #              to search.nixos.org,
  # - a list:    that will be interpreted as an attribute path from `pkgs` and turned into a link
  #              to search.nixos.org,
  # - an attrset: that can specify `name`, `path`, `comment`
  #   (either of `name`, `path` is required, the rest are optional).
  #
  # NOTE: No checks against `pkgs` are made to ensure that the referenced package actually exists.
  # Such checks are not compatible with option docs caching.
  genRelatedPackages = packages: optName:
    let
      unpack = p: if lib.isString p then { name = p; }
                  else if lib.isList p then { path = p; }
                  else p;
      describe = args:
        let
          title = args.title or null;
          name = args.name or (lib.concatStringsSep "." args.path);
        in ''
          - [`${lib.optionalString (title != null) "${title} aka "}pkgs.${name}`](
              https://search.nixos.org/packages?show=${name}&sort=relevance&query=${name}
            )${
              lib.optionalString (args ? comment) "\n\n  ${args.comment}"
            }
        '';
    in lib.concatMapStrings (p: describe (unpack p)) packages;

  optionsNix = builtins.listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) optionsList);

in rec {
  inherit optionsNix;

  optionsAsciiDoc = pkgs.runCommand "options.adoc" {} ''
    ${pkgs.python3Minimal}/bin/python ${./generateDoc.py} \
      --format asciidoc \
      ${optionsJSON}/share/doc/nixos/options.json \
      > $out
  '';

  optionsCommonMark = pkgs.runCommand "options.md" {} ''
    ${pkgs.python3Minimal}/bin/python ${./generateDoc.py} \
      --format commonmark \
      ${optionsJSON}/share/doc/nixos/options.json \
      > $out
  '';

  optionsJSON = pkgs.runCommand "options.json"
    { meta.description = "List of NixOS options in JSON format";
      nativeBuildInputs = [
        pkgs.brotli
        pkgs.python3Minimal
      ];
      options = builtins.toFile "options.json"
        (builtins.unsafeDiscardStringContext (builtins.toJSON optionsNix));
      # merge with an empty set if baseOptionsJSON is null to run markdown
      # processing on the input options
      baseJSON =
        if baseOptionsJSON == null
        then builtins.toFile "base.json" "{}"
        else baseOptionsJSON;
    }
    ''
      # Export list of options in different format.
      dst=$out/share/doc/nixos
      mkdir -p $dst

      TOUCH_IF_DB=$dst/.used-docbook \
      python ${./mergeJSON.py} \
        ${lib.optionalString warningsAreErrors "--warnings-are-errors"} \
        ${if allowDocBook then "--warn-on-docbook" else "--error-on-docbook"} \
        $baseJSON $options \
        > $dst/options.json

      brotli -9 < $dst/options.json > $dst/options.json.br

      mkdir -p $out/nix-support
      echo "file json $dst/options.json" >> $out/nix-support/hydra-build-products
      echo "file json-br $dst/options.json.br" >> $out/nix-support/hydra-build-products
    '';

  optionsUsedDocbook = pkgs.runCommand "options-used-docbook" {} ''
    if [ -e ${optionsJSON}/share/doc/nixos/.used-docbook ]; then
      echo 1
    else
      echo 0
    fi >"$out"
  '';

  optionsDocBook = pkgs.runCommand "options-docbook.xml" {
    MANPAGE_URLS = pkgs.path + "/doc/manpage-urls.json";
    OTD_DOCUMENT_TYPE = documentType;
    OTD_VARIABLE_LIST_ID = variablelistId;
    OTD_OPTION_ID_PREFIX = optionIdPrefix;
    OTD_REVISION = revision;

    nativeBuildInputs = [
      (let
        # python3Minimal can't be overridden with packages on Darwin, due to a missing framework.
        # Instead of modifying stdenv, we take the easy way out, since most people on Darwin will
        # just be hacking on the Nixpkgs manual (which also uses make-options-doc).
        python = if pkgs.stdenv.isDarwin then pkgs.python3 else pkgs.python3Minimal;
        self = (python.override {
          inherit self;
          includeSiteCustomize = true;
        });
      in self.withPackages (p:
        let
          # TODO add our own small test suite when rendering is split out into a new tool
          markdown-it-py = p.markdown-it-py.override {
            disableTests = true;
          };
          mdit-py-plugins = p.mdit-py-plugins.override {
            inherit markdown-it-py;
            disableTests = true;
          };
        in [
          markdown-it-py
          mdit-py-plugins
        ]))
    ];
  } ''
    python ${./optionsToDocbook.py} \
      ${lib.optionalString markdownByDefault "--markdown-by-default"} \
      ${optionsJSON}/share/doc/nixos/options.json \
      > options.xml

    if grep /nixpkgs/nixos/modules options.xml; then
      echo "The manual appears to depend on the location of Nixpkgs, which is bad"
      echo "since this prevents sharing via the NixOS channel.  This is typically"
      echo "caused by an option default that refers to a relative path (see above"
      echo "for hints about the offending path)."
      exit 1
    fi

    ${pkgs.libxslt.bin}/bin/xsltproc \
      -o "$out" ${./postprocess-option-descriptions.xsl} options.xml
  '';
}
