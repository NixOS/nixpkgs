{ pkgs, lib }:
let
  inherit (lib.attrsets)
    attrNames
    filterAttrs
    foldlAttrs
    mapAttrsToList
    mergeAttrsList
    zipAttrsWith
    ;
  inherit (lib.lists) sortOn map naturalSort;

  isPythonInterpreterName = name: (lib.strings.match "(pypy|python)([[:digit:]]*)" name) != null;
  aliasFilterWithExcludes = excludeList: name:
    isPythonInterpreterName name &&
    ! builtins.elem name excludeList;

  /* NB: About pkNames that don't follow the regular expression:
    - `python-cosmopolitan` is not part of `pkgs.pythonInterpreters`.
    - `_prebuilt` interpreters are used for bootstrapping internally.
    - `python3Minimal` contains python packages, left behind conservatively.
    - `rustpython` lacks `pythonVersion` and `implementation`.
  */
  interpreterFilter = aliasFilterWithExcludes [];
  interpreters = import ./interpreters.nix {
    inherit lib;
    inherit (pkgs) pythonInterpreters;
  };
  /* Look for aliases in the attrset `pkgs`.

  Two packages <attrname1> has and alias <attrname2> they return the same <table-fied-value> .

  The return type is an attrset with the following shape:

  ```
  {
    ${interpreterFieldValue} = { interpreter = [ <alias1> <alias2> ... ]] };
    ....
  }
  ```

  Example:

  ```
  {
    "CPython 3.10" = { aliases = [ "python310" ]; };
    "CPython 3.11" = { aliases = [ "python3" "python311" ]; };
    "PyPy 3.10" = { aliases = [ "pypy310" ]; };
    ....
  }
  ```
  */
  aliases =
    let
      # Collect interpreter keys to be excluded from the aliases set
      excludeList = mapAttrsToList (_: value: value.attrname) interpreters;
      aliasFilter = aliasFilterWithExcludes excludeList;
      aliases' = filterAttrs (name: _: aliasFilter name) pkgs;
      foldFn = (acc: name: value: let
        interpreter = import ./nix/interpreterFieldValue.nix { python = value; };
      in acc // {
        ${interpreter} = {
          aliases = (acc.${interpreter}.aliases or []) ++ [name];
        };
      });
    in
    foldlAttrs foldFn {} aliases';

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
