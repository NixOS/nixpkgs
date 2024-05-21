{ pkgs, lib }:
let
  inherit (lib.attrsets)
    attrNames
    filterAttrs
    foldlAttrs
    mapAttrs'
    mapAttrsToList
    mergeAttrsList
    nameValuePair
    zipAttrsWith
    ;
  inherit (lib.lists) sortOn map naturalSort;
  inherit (lib.strings) hasInfix hasPrefix hasSuffix;

  interpreterName = python:
    let
      cuteName = {
        cpython = "CPython";
        pypy = "PyPy";
      };
    in ''${cuteName.${python.implementation}} ${python.pythonVersion}'';

  isPythonInterpreter = name:
    /* NB: Package names that don't follow the regular expression:
      - `python-cosmopolitan` is not part of `pkgs.pythonInterpreters`.
      - `_prebuilt` interpreters are used for bootstrapping internally.
      - `python3Minimal` contains python packages, left behind conservatively.
      - `rustpython` lacks `pythonVersion` and `implementation`.
    */
    (lib.strings.match "(pypy|python)([[:digit:]]*)" name) != null;

  isAlias = excludeList: name:
    isPythonInterpreter name && ! builtins.elem name excludeList;

  /* Collect Python interpreters from attrset `pkgs.pythonInterpreters`.

  The return type is an attrset with the following shape:
  ```
  {
    ${interpreterName} = {
      interpreter = ${interpreterName};
      attrname = ${attrname};
    };
    ....
  }
  ```

  Example:

  ```
  {
    "CPython 3.10" = { attrname = "python310"; };
    "PyPy 3.10" = { attrname = "pypy310"; };
    ....
  }
  ```
  */
  interpreters =
    let
      filtered = filterAttrs (name: _: isPythonInterpreter name) pkgs.pythonInterpreters;
    in
    mapAttrs'
      (name: value: { name = interpreterName value; value = { attrname = name; }; })
      filtered;
  /* Look for aliases in the attrset `pkgs`.

  Two packages <attrname1> has and alias <attrname2> they return the same <table-fied-value> .

  The return type is an attrset with the following shape:

  ```
  {
    ${interpreterName} = { interpreter = [ <alias1> <alias2> ... ]] };
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
      filtered = filterAttrs (name: _: isAlias excludeList name) pkgs;
      collectAliases = (acc: name: value:
        let
          interpreter = interpreterName value;
        in acc // {
          ${interpreter} = {
            aliases = (acc.${interpreter}.aliases or []) ++ [name];
          };
        });
    in
    foldlAttrs collectAliases {} filtered;

  /*
  Combine results from interpreters and aliases:
  {
    "CPython 3.10" = { aliases = [ ]; attrname = [ "python310" ]; };
    "CPython 3.11" = { aliases = [ "python3" ]; attrname = [ "python311" ]; };
  }
  */
  result = zipAttrsWith (_: values: mergeAttrsList values) [ aliases interpreters ];

  /*
  Return a list of table rows as attrsets, sorted by interpreter name and version:
  [
    { attrname = "python310"; aliases = [ ]; interpreter = "CPython 3.10"; }
    { attrname = "python311"; aliases = [ "python3" ]; interpreter = "CPython 3.11"; }
  ]
  */
  toRows = data:
    map (interpreter: data.${interpreter} // { inherit interpreter; }) (naturalSort (attrNames data));

in
toRows result
