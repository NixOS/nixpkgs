{ pkgs, lib }:
let
  inherit (lib.attrsets) attrNames mapAttrsToList mergeAttrsList zipAttrsWith;
  inherit (lib.lists) sortOn map;

  interpreters = import ./interpreters.nix {
    inherit lib;
    inherit (pkgs) pythonInterpreters;
  };
  aliases =
    let
      # Collect interpreter keys to be excluded from the aliases set
      excludeList = mapAttrsToList (_: value: value.pkgKey) interpreters;
    in
    import ./aliases.nix { inherit pkgs lib excludeList; };

  #  Combine results from interpreters and aliases zipped by ${interpreterFieldValue}.
  tableData = zipAttrsWith (_: values: values) [ aliases interpreters ];

  /* Return a list of table rows as attrsets.
    The table columns are ${pkgKey}, ${aliases} and ${interpreterFieldValue}.
  */
  toRows = data:
    let
      toComparable = import ./nix/toComparable.nix { inherit lib; };
      # Get a sorted list with the table data keys.
      tableEntryKeyList = sortOn toComparable (attrNames data);
    in
    # For each key in the sorted list merge their previously zipped values.
    map (key: mergeAttrsList data.${key}) tableEntryKeyList;

in
toRows tableData
