# To build this derivation, run `nix-build -A nixpkgs-manual.pythonInterpreterTable`
{
  lib,
  writeText,
  pkgs,
  pythonInterpreters,
}:
let
  isPythonInterpreter =
    name:
    /*
      NB: Package names that don't follow the regular expression:
      - `python-cosmopolitan` is not part of `pkgs.pythonInterpreters`.
      - `_prebuilt` interpreters are used for bootstrapping internally.
      - `python3Minimal` contains python packages, left behind conservatively.
      - `rustpython` lacks `pythonVersion` and `implementation`.
    */
    (lib.strings.match "(pypy|python)([[:digit:]]*)" name) != null;

  interpreterName =
    pname:
    let
      cuteName = {
        cpython = "CPython";
        pypy = "PyPy";
      };
      interpreter = pkgs.${pname};
    in
    "${cuteName.${interpreter.implementation}} ${interpreter.pythonVersion}";

  interpreters = lib.reverseList (
    lib.naturalSort (lib.filter isPythonInterpreter (lib.attrNames pythonInterpreters))
  );

  aliases =
    pname:
    lib.attrNames (
      lib.filterAttrs (
        name: value:
        isPythonInterpreter name && name != pname && interpreterName name == interpreterName pname
      ) pkgs
    );

  result = map (pname: {
    inherit pname;
    aliases = aliases pname;
    interpreter = interpreterName pname;
  }) interpreters;

  toMarkdown =
    data:
    let
      line = package: ''
        | ${package.pname} | ${lib.concatStringsSep ", " package.aliases or [ ]} | ${package.interpreter} |
      '';
    in
    lib.concatStringsSep "" (map line data);

in
writeText "python-interpreter-table.md" ''
  | Package | Aliases | Interpeter |
  |---------|---------|------------|
  ${toMarkdown result}
''
