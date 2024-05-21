{ lib }:
rec {
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
}
