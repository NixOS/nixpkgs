{ pkgs, lib }:
let
  inherit (lib.attrsets) attrNames mapAttrsToList mergeAttrsList zipAttrsWith;
  inherit (lib.lists) sortOn map naturalSort;

  interpreters = import ./interpreters.nix {
    inherit lib;
    inherit (pkgs) pythonInterpreters;
  };
  aliases =
    let
      # Collect interpreter keys to be excluded from the aliases set
      excludeList = mapAttrsToList (_: value: value.attrname) interpreters;
    in
    import ./aliases.nix { inherit pkgs lib excludeList; };

  #  Combine results from interpreters and aliases zipped by ${interpreterFieldValue}.
  tableData = zipAttrsWith (_: values: values) [ aliases interpreters ];

  /* Return a list of table rows as attrsets.
    The table columns are ${attrname}, ${aliases} and ${interpreterFieldValue}.
  */
  toRows = data:
    # For each key in the sorted list merge their previously zipped values.
    map (key: mergeAttrsList data.${key}) (naturalSort (attrNames data));

in
toRows tableData
