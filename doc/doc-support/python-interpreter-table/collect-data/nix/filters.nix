# `attrname` must follow the regex `r"(pypy|python)(\d*)"` (Python flavor)
{ lib }:
let
  aliasFilterWithExcludes = excludeList: attrname:
    let
      inherit (lib.strings) removePrefix toIntBase10;
      # It's faster to prepend a 0 and call `toIntBase10` than to check if the suffix is ""
      nameSuffix = "0" + (removePrefix "python" (removePrefix "pypy" attrname));
    in
      ((lib.strings.hasPrefix "python" attrname) || (lib.strings.hasPrefix "pypy" attrname)) &&
      # If the suffix contains more than an int number, then it isn't an interpreter alias
      (builtins.tryEval(toIntBase10 nameSuffix)).success &&
      # Aliases are not part of the `pkgs.pythonInterpreters` attrs
      ! builtins.elem attrname excludeList;

in {
  inherit aliasFilterWithExcludes;

  /* NB: About pkNames that don't follow the regular expression:
    - `python-cosmopolitan` is not part of `pkgs.pythonInterpreters`.
    - `_prebuilt` interpreters are used for bootstrapping internally.
    - `python3Minimal` contains python packages, left behind conservatively.
    - `rustpython` lacks `pythonVersion` and `implementation`.
  */
  interpreterFilter = aliasFilterWithExcludes [];
}
