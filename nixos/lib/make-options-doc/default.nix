/**
  Generates documentation for [nix modules](https://nix.dev/tutorials/module-system/index.html).

  It uses the declared `options` to generate documentation in various formats.

  # Outputs

  This function returns an attribute set with the following entries.

  ## optionsCommonMark

  Documentation in CommonMark text format.

  ## optionsJSON

  All options in a JSON format suitable for further automated processing.

  `example.json`
  ```json
  {
    ...
    "fileSystems.<name>.options": {
      "declarations": ["nixos/modules/tasks/filesystems.nix"],
      "default": {
        "_type": "literalExpression",
        "text": "[\n  \"defaults\"\n]"
      },
      "description": "Options used to mount the file system.",
      "example": {
        "_type": "literalExpression",
        "text": "[\n  \"data=journal\"\n]"
      },
      "loc": ["fileSystems", "<name>", "options"],
      "readOnly": false,
      "type": "non-empty (list of string (with check: non-empty))"
      "relatedPackages": "- [`pkgs.tmux`](\n    https://search.nixos.org/packages?show=tmux&sort=relevance&query=tmux\n  )\n",
    },
    ...
  }
  ```

  ## optionsDocBook

  deprecated since 23.11 and will be removed in 24.05.

  ## optionsAsciiDoc

  Documentation rendered as AsciiDoc. This is useful for e.g. man pages.

  > Note: NixOS itself uses this ouput to to build the configuration.nix man page"

  ## optionsNix

  All options as a Nix attribute set value, with the same schema as `optionsJSON`.

  # Example

  ## Example: NixOS configuration

  ```nix
  let
    # Evaluate a NixOS configuration
    eval = import (pkgs.path + "/nixos/lib/eval-config.nix") {
      # Overriden explicitly here, this would include all modules from NixOS otherwise.
      # See: docs of eval-config.nix for more details
      baseModules = [];
      modules = [
        ./module.nix
      ];
    };
  in
    pkgs.nixosOptionsDoc {
      inherit (eval) options;
    }
  ```

  ## Example: non-NixOS modules

  `nixosOptionsDoc` can also be used to build documentation for non-NixOS modules.

  ```nix
  let
    eval = lib.evalModules {
      modules = [
        ./module.nix
      ];
    };
  in
    pkgs.nixosOptionsDoc {
      inherit (eval) options;
    }
  ```
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
# deprecated since 23.11.
# TODO remove in a while.
, allowDocBook ? false
# TODO remove in a while (see https://github.com/NixOS/nixpkgs/issues/300735)
, markdownByDefault ? true
}:

assert markdownByDefault && ! allowDocBook;

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
          - [${lib.optionalString (title != null) "${title} aka "}`pkgs.${name}`](
              https://search.nixos.org/packages?show=${name}&sort=relevance&query=${name}
            )${
              lib.optionalString (args ? comment) "\n\n  ${args.comment}"
            }
        '';
    in lib.concatMapStrings (p: describe (unpack p)) packages;

  optionsNix = builtins.listToAttrs (map (o: { name = o.name; value = removeAttrs o ["name" "visible" "internal"]; }) optionsList);

in rec {
  inherit optionsNix;

  optionsAsciiDoc = pkgs.runCommand "options.adoc" {
    nativeBuildInputs = [ pkgs.nixos-render-docs ];
  } ''
    nixos-render-docs -j $NIX_BUILD_CORES options asciidoc \
      --manpage-urls ${pkgs.path + "/doc/manpage-urls.json"} \
      --revision ${lib.escapeShellArg revision} \
      ${optionsJSON}/share/doc/nixos/options.json \
      $out
  '';

  optionsCommonMark = pkgs.runCommand "options.md" {
    nativeBuildInputs = [ pkgs.nixos-render-docs ];
  } ''
    nixos-render-docs -j $NIX_BUILD_CORES options commonmark \
      --manpage-urls ${pkgs.path + "/doc/manpage-urls.json"} \
      --revision ${lib.escapeShellArg revision} \
      ${optionsJSON}/share/doc/nixos/options.json \
      $out
  '';

  optionsJSON = pkgs.runCommand "options.json"
    { meta.description = "List of NixOS options in JSON format";
      nativeBuildInputs = [
        pkgs.brotli
        pkgs.python3
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
        $baseJSON $options \
        > $dst/options.json

    if grep /nixpkgs/nixos/modules $dst/options.json; then
      echo "The manual appears to depend on the location of Nixpkgs, which is bad"
      echo "since this prevents sharing via the NixOS channel.  This is typically"
      echo "caused by an option default that refers to a relative path (see above"
      echo "for hints about the offending path)."
      exit 1
    fi

      brotli -9 < $dst/options.json > $dst/options.json.br

      mkdir -p $out/nix-support
      echo "file json $dst/options.json" >> $out/nix-support/hydra-build-products
      echo "file json-br $dst/options.json.br" >> $out/nix-support/hydra-build-products
    '';

  optionsDocBook = throw "optionsDocBook has been removed in 24.05";
}
