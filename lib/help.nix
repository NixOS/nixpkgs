{ lib, ... }:
let
  inherit (lib) any attrValues concatStringsSep filterAttrs isAttrs isDerivation mapAttrs mapAttrsToList;
in rec {
  internal = rec {
    mapAttrsNestedRecursiveCond = pred: f: set:
      let
        recurse = path: set:
          let
            g = name: value:
              let value' = f (path ++ [name]) value; in
              if pred value && isAttrs value'
                then recurse (path ++ [name]) value'
                else value';
          in mapAttrs g set;
      in recurse [] set;

    annotate = msg: x: { __orig = x; __help = msg; };
    hasHelp = x: isAttrs x && x ? __orig && x ? __help;
    showHelpLines = path: msg: x:
      if isAttrs x && !(isDerivation x) then ["" "${concatStringsSep "." path}: ${msg}"]
      else ["${concatStringsSep "." path} - ${msg}"];
    eraseHelp = mapAttrsNestedRecursiveCond (_: true) (_name: value: if hasHelp value then value.__orig else value);
    buildHelp =
      let
        recurse = path: as:
          let
            next = if hasHelp as then as.__orig else as;
            nextAttrs = if isAttrs next then filterAttrs (_name: hasHelp) next else {};
          in
            concatStringsSep "\n" (
              (if hasHelp as then showHelpLines path as.__help as.__orig else []) ++
              (builtins.filter (x: x != "")
                (mapAttrsToList (name: value: recurse (path ++ [name]) value) nextAttrs)
              )
            );
      in recurse [];
    };

  # Adds help documentation to an attrset used for nix-build/nix-shell (often in default.nix).
  #
  # withHelp' :: AttrSet -> ((String -> Any -> Any) -> AttrSet -> AttrSet) -> AttrSet
  #
  # Given an attrset annotated with help information, `withHelp'` will return an attrset with
  # all annotations erased and up to two additional attributes:
  #    * help: An attribute that throws an error describing all the documented targets
  #    * all: An attribute that returns the original, unannotated attrset for use in building
  #           all targets at once.
  #
  # Example:
  #     let x = withHelp' {} (help: self: {
  #       package = help "This is a package" pkg;
  #       packageAlias = help "DEPRECATED: Use package instead" self.package;
  #
  #       subset = help "Sub-targets" {
  #         helper = help "A helper utility" helperPkg;
  #       };
  #     })
  #
  #  Evaluating `x.help` produces:
  #    error: Help:
  #
  #    The following targets are documented:
  #
  #    package - This is a package
  #    packageAlias - DEPRECATED: Use package instead
  #
  #    subset: Sub-targets
  #    subset.helper - A helper utility
  #
  #  And evaluating `x.subset.helper` builds the `helperPkg`.
  #
  #  Here `help` is a function that annotates an attribute with a string.
  #  If you annotate an attrset that itself contains more annotated attrsets,
  #  the documentation will recurse.
  #
  #  `self` is a reference to the unannotated attrset that will be returned
  #  by `withHelp'`. You must use this instead of `rec { ... }` since built-in
  #  recursive attrsets will not strip off the annotations.
  withHelp' =
    { helpAttribute ? "help"
    , wrapper ? (docs: "Help:\n\nThe following targets are documented:\n\n" + docs)
    , throw ? builtins.throw
    , allAttribute ? "all"
    , ...
    }: mkAttrs:
    let
      attrs = mkAttrs internal.annotate self;
      self = internal.eraseHelp attrs;
    in self // {
      ${helpAttribute} = throw (wrapper (internal.buildHelp attrs));
      ${allAttribute} = self;
    };

  # Like `withHelp'` but using the default configuration:
  #   `help` is the name of the attribute for throwing the help message.
  #   `all` is the name of the attribute for building all attributes.
  #   A default header message is provided.
  withHelp = withHelp' {};
}
