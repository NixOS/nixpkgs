{ lib, pkgs, ... }:
let
  maintainer = lib.mkOptionType {
    name = "maintainer";
    check = email: lib.elem email (lib.attrValues lib.maintainers);
    merge =
      loc: defs:
      lib.listToAttrs (lib.singleton (lib.nameValuePair (lib.last defs).file (lib.last defs).value));
  };

  listOfMaintainers = lib.types.listOf maintainer // {
    # Returns list of
    #   { "module-file" = [
    #        "maintainer1 <first@nixos.org>"
    #        "maintainer2 <second@nixos.org>" ];
    #   }
    merge =
      loc: defs:
      lib.zipAttrs (
        lib.flatten (
          lib.imap1 (
            n: def:
            lib.imap1 (
              m: def':
              maintainer.merge (loc ++ [ "[${toString n}-${toString m}]" ]) [
                {
                  inherit (def) file;
                  value = def';
                }
              ]
            ) def.value
          ) defs
        )
      );
  };

  docFile = lib.types.path // {
    # Returns tuples of
    #   { file = "module location"; value = <path/to/doc.xml>; }
    merge = loc: defs: defs;
  };

  /**
    Append default.nix the path is a directory. Unknown paths such as custom _file strings are assumed not to be directories.
  */
  resolveDefaultNix =
    p: if lib.pathExists p && lib.pathType p == "directory" then p + "/default.nix" else p;

  /**
    Custom type for `meta.tests` option.
  */
  testsType = lib.mkOptionType {
    name = "tests";
    check = lib.isFunction;
    merge = _loc: defs: rec {
      byModulePath =
        lib.zipAttrsWith
          (
            _fileName: values:
            # These are per file, so we don't need to merge definitions.
            # We could, but it's not implemented yet.
            assert (lib.length values == 1);
            lib.head values { inherit (pkgs) nixosTests; }
          )
          (
            map (
              { file, value, ... }:
              {
                "${toString (resolveDefaultNix file)}" = value;
              }
            ) defs
          );
      /**
        Given a list of file names, return a nested attribute set of tests to run, in an efficient lexicographic order.
      */
      filter =
        paths:
        let
          pathSet = lib.genAttrs (map (p: toString (resolveDefaultNix p)) paths) (_path: null);
          relevant = builtins.intersectAttrs pathSet byModulePath;

          # Optimize evaluation order by sorting by test name. This way, even
          # if multiple files reference the same tests, and if you split
          # evaluation, you can likely resume from a given point in the nested
          # attrset without encountering already evaluated tests again. (or
          # split work across multiple processes)
          /**
            An attrset structure of <testName>.<fileName> = derivation;
          */
          transposed = lib.zipAttrsWith (_k: lib.mergeAttrsList) (
            lib.mapAttrsToList (fileName: values: lib.mapAttrs (k: v: { "${fileName}" = v; }) values) relevant
          );

        in
        transposed;

      /**
        Given a list of file names, return a list of test derivations for `nix-build`.

        This is like `filter`, but solves the problem that `nix-build` ignores attributes with `.` in their names.
      */
      filterForNixBuild =
        paths:
        let
          flattenPackageSet = ps: lib.attrValues (lib.removeAttrs ps [ "recurseForDerivations" ]);
        in
        # Two calls to `flattenPackageSet` because we have exactly two layers to flatten.
        lib.concatMap flattenPackageSet (flattenPackageSet (filter paths));
    };
  };

in

{
  options = {
    meta = {

      maintainers = lib.mkOption {
        type = listOfMaintainers;
        internal = true;
        default = [ ];
        example = lib.literalExpression ''[ lib.maintainers.all ]'';
        description = ''
          List of maintainers of each module.  This option should be defined at
          most once per module.
        '';
      };

      doc = lib.mkOption {
        type = docFile;
        internal = true;
        example = "./meta.chapter.md";
        description = ''
          Documentation prologue for the set of options of each module.  This
          option should be defined at most once per module.
        '';
      };

      buildDocsInSandbox = lib.mkOption {
        type = lib.types.bool // {
          merge = loc: defs: defs;
        };
        internal = true;
        default = true;
        description = ''
          Whether to include this module in the split options doc build.
          Disable if the module references `config`, `pkgs` or other module
          arguments that cannot be evaluated as constants.

          This option should be defined at most once per module.
        '';
      };

      tests = lib.mkOption {
        type = testsType;
        description = ''
          Tests for particular modules.

          Definitions are tied to the location of the module, so the definition syntax is distinct from the option value format.

          For example, this definition:
          ```nix
          # module.nix
          {
            meta.tests =
              { nixosTests }:
              {
                inherit (nixosTests) foo;
              };
          }
          ```

          ... produces the option value:

          ```nix
          { nixosTests }:
          {
            byPath = {
              "/path/to/module.nix" = {
                foo = nixosTests.foo;
              };
              # ...
            };
            filter = paths: { ... };
            filterForNixBuild = paths: [ ... ];
          }
          ```

          The filter functions have `nix repl` `:doc` documentation.

          This can be used for tooling to figure out which tests are relevant, given a set of changed files.
        '';
      };
    };
  };

  config.meta = {
    # Make the option value valid even if not loaded into e.g. a NixOS with real definitions.
    tests =
      { nixosTests }:
      {
        inherit (nixosTests) meta;
      };
  };

  meta.maintainers = [
    lib.maintainers.pierron
    lib.maintainers.roberth
  ];
}
