/* Look for aliases in the attrset `pkgs`.

Two packages <pkgKey1> has and alias <pkgKey2> they return the same <table-fied-value> .

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
{ lib, pkgs, excludeList }: let
  inherit (lib.attrsets) filterAttrs foldlAttrs;
  inherit (import ./nix/filters.nix { inherit lib; }) aliasFilterWithExcludes;

  aliasFilter = aliasFilterWithExcludes excludeList;
  aliases = filterAttrs (name: _: aliasFilter name) pkgs;

  foldFn = (acc: name: value: let
    interpreter = import ./nix/interpreterFieldValue.nix { python = value; };
  in acc // {
    ${interpreter} = {
      aliases = (acc.${interpreter}.aliases or []) ++ [name];
    };
  });

in foldlAttrs foldFn {} aliases
