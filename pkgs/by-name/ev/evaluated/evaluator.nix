let

  pkgs = import <nixpkgs> { };
  inherit (pkgs.lib)
    concatStringsSep
    isDerivation
    isFunction
    isAttrs
    mapAttrs
    ;
  /**
    Helper for package tree introspection.

    It emits the position of all functions
    and derivations using `builtins.trace`
    so that another program can quickly calculate
    the difference of packages between two commits.
  */
  traceTree =
    let
      traceTree' =
        tree: path:
        let
          pathStr = concatStringsSep "." path;
          evaluated = builtins.tryEval tree;
        in
        if isFunction tree then
          builtins.trace ":tree: function ${pathStr} :tree:" null
        else if !evaluated.success then
          builtins.trace ":tree: exception ${pathStr} :tree:" null
        else if isDerivation tree then
          builtins.trace (builtins.unsafeDiscardStringContext ":tree: derivation ${pathStr} ${tree.drvPath} :tree:") null
        else if isAttrs tree && (tree.recurseForDerivations or false) then
          mapAttrs (k: v: traceTree' v (path ++ [ k ])) (pkgs.recurseIntoAttrs tree)
        else
          null;
    in
    tree: traceTree' tree [ ];
in
traceTree (pkgs.recurseIntoAttrs pkgs)
