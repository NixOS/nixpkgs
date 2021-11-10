{ lib }:
let
  inherit (builtins)
    attrValues
    concatStringsSep
    length
    mapAttrs
    tryEval
    isAttrs
  ;
  inherit (lib)
    any
    flatten
    isDerivation
    optional
    types
    concatLists
    mapAttrsToList
  ;
  isAttr = types.attrs.check;
in
rec {
  /* Return a list of maintainers from a package, empty list if inaccessible.

     Example:
       listMaintainers pkgs.foo
       => [ { name = "Foo Bar"; email = "name@domain.com"; github = "foo"; } ]
       listMaintainers pkgs.bar
       => [ ]
       listMaintainers {}
       => error: listMaintainers must receive a package
  */
  listMaintainers =
  # Must be a package
  p:
    if isDerivation p then
      p.meta.maintainers or []
    else
      throw "listMaintainers must receive a package"
  ;

  /* Returns if a package has a maintainer (i.e.: not orphan).

     Example:
       hasMaintainer pkgs.foo
       => true
       hasMaintainer pkgs.bar
       => false
       hasMaintainer {}
       => error: listMaintainers must receive a package
  */
  hasMaintainer =
  # Must be a package
  p:
    (listMaintainers p) != [];

  /* Returns a list of addresses from the node attrset/package of orphan packages.

     It works recursively, so theorically you can find unmaintained packages in the whole nixpkgs.
     However, evaluation errors halt the execution, and these type of errors can't be caught by builtins.tryEval.
     So prefer to use it in smaller package sets you might be interested.

     Example:
       listOrphans { node = pkgs; }
       => [ "bar" ]
       listOrphans { node = pkgs; minMaintainers = 2; }
       => [ "foo" "bar" ]
       listOrphans { node = pkgs; minMaintainers = 2; recur = [ "pkgs" ]; }
       => [ [ "pkgs" "foo" ] [ "pkgs" "bar" ] ]
  */
  listOrphans =
    {
    # The packages
    packages,
    # Maximum recursion depth.
    maxDepth ? 20,
    # The minimum maintainer amount necessary to not put the package on the return list.
    minMaintainers ? 1
  }:
    let
      go = path: maxDepth: packages:
        let
          fun = name: value:
            let
              result = tryEval value;
              path' = path ++ [ name ];
            in
            if ! result.success then []
            else if ! isAttrs result.value then []
            else if isDerivation result.value then
              optional (length (listMaintainers result.value) < minMaintainers) path'
            else if ! (result.value.recurseForDerivations or false) then []
            else go path' (maxDepth - 1) result.value;
        in if maxDepth <= 0 then []
        else concatLists (mapAttrsToList fun packages);
    in go [] maxDepth packages;
}
