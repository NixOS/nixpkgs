# For debugging, run in this directory:
#     nix eval --impure --raw --expr 'import ./python-interpreter-table.nix {}'
{ pkgs ? (import ../.. { config = { }; overlays = []; }) }:
let
  lib = pkgs.lib;
  inherit (lib.attrsets) attrNames filterAttrs;
  inherit (lib.lists) elem filter map naturalSort reverseList;
  inherit (lib.strings) concatStringsSep;

  isPythonInterpreter = name:
    /* NB: Package names that don't follow the regular expression:
      - `python-cosmopolitan` is not part of `pkgs.pythonInterpreters`.
      - `_prebuilt` interpreters are used for bootstrapping internally.
      - `python3Minimal` contains python packages, left behind conservatively.
      - `rustpython` lacks `pythonVersion` and `implementation`.
    */
    (lib.strings.match "(pypy|python)([[:digit:]]*)" name) != null;

  interpreterName = pname:
    let
      cuteName = {
        cpython = "CPython";
        pypy = "PyPy";
      };
      interpreter = pkgs.${pname};
    in
    "${cuteName.${interpreter.implementation}} ${interpreter.pythonVersion}";

  interpreters = reverseList (naturalSort (
    filter isPythonInterpreter (attrNames pkgs.pythonInterpreters)
  ));

  aliases = pname:
    attrNames (
      filterAttrs (name: value:
        isPythonInterpreter name
        && name != pname
        && interpreterName name == interpreterName pname
      ) pkgs
    );

  result = map (pname: {
    inherit pname;
    aliases = aliases pname;
    interpreter = interpreterName pname;
  }) interpreters;

  toMarkdown = data:
    let
      line = package: ''
        | ${package.pname} | ${join ", " package.aliases or [ ]} | ${package.interpreter} |
      '';
    in
    join "" (map line data);

  join = lib.strings.concatStringsSep;

in
''
  | Package | Aliases | Interpeter |
  |---------|---------|------------|
  ${toMarkdown result}
''
