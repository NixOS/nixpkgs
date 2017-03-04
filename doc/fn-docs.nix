# Assume that there is only one level of nesting in lib.
#
with builtins;
let
  pkgs = import ./.. {};
  inherit (pkgs) lib;
  sets = filter (x: (typeOf lib.${x}) == "set") (attrNames lib);

  filterDocumentedFunctions = set:
    let
      isSet = n: (typeOf set.${n}) == "set";
      hasType = n: set.${n} ? type;
      predicate = x: isSet x && hasType x && lib.${x}.type=="documentedFunction";
    in filter predicate (attrNames set);

  mkDocs = fn: let
    examples = if fn.example != null
      then (assert fn.examples == []; [ fn.example ])
      else fn.examples;
  in { inherit (fn) description; inherit examples; };

  topLevelDocumentedFunctions =
    let
      documentedFunctions = filterDocumentedFunctions lib;
    in map (n: {name = ["lib" n]; docs = mkDocs lib.${n};  }) documentedFunctions;

  find_functions = set:
    let
      set_val = lib.${set};
      documentedFunctions = filterDocumentedFunctions set_val;
    in map (n: {name = ["lib" set n]; docs = mkDocs set_val.${n};  }) documentedFunctions;
in
{
  categorized = concatLists (map find_functions sets);
  topLevel = topLevelDocumentedFunctions;
}
