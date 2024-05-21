/* Collect Python interpreters from attrset `pkgs.pythonInterpreters`.

The return type is an attrset with the following shape:
```
{
  ${interpreterFieldValue} = {
    interpreter = ${interpreterFieldValue};
    attrname = ${attrname};
  };
  ....
}
```

Example:

```
{
  "CPython 3.10" = { interpreter = "CPython 3.10"; attrname = "python310"; };
  "PyPy 3.10" = { interpreter = "PyPy 3.10"; attrname = "pypy310"; };
  ....
}
```
*/
{ lib, pythonInterpreters }: let
  inherit (lib.attrsets) filterAttrs mapAttrs' nameValuePair;
  inherit (lib.strings) hasInfix hasPrefix hasSuffix;

  inherit (import ./nix/filters.nix { inherit lib; }) interpreterFilter;

  interpreters = filterAttrs
    (name: _: interpreterFilter name)
    pythonInterpreters;

in mapAttrs'
    (name: value: let
      interpreterFieldValue =
        (import ./nix/interpreterFieldValue.nix { python = value; });
    in nameValuePair
      interpreterFieldValue
      {
        interpreter = interpreterFieldValue;
        attrname = name;
      })
    interpreters
