{
  lib,
}:
let
  fixtures = [
    rec {
      input = "name@version-1.2.3";
      expected = {
        fullString = input;
        registry = null;
        scope = null;
        name = "name";
        version = "version-1.2.3";
        suffix = null;
      };
    }
    rec {
      input = "registry:@scope/name@version-1.2.3_name@version-1.2.3_name@version-1.2.3";
      expected = {
        fullString = input;
        registry = "registry";
        scope = "scope";
        name = "name";
        version = "version-1.2.3";
        suffix = "name@version-1.2.3_name@version-1.2.3";
      };
    }
    rec {
      input = "@scope/name@version-1.2.3_name@version-1.2.3";
      expected = {
        fullString = input;
        registry = null;
        scope = "scope";
        name = "name";
        version = "version-1.2.3";
        suffix = "name@version-1.2.3";
      };
    }
    rec {
      input = "name@version-1.2.3_name@version-1.2.3";
      expected = {
        fullString = input;
        registry = null;
        scope = null;
        name = "name";
        version = "version-1.2.3";
        suffix = "name@version-1.2.3";
      };
    }
  ];
  parsePackageSpecifier =
    fullString:
    let
      regex1 = "^((.*):)?(@(.*)\/)?(.*)$";
      matches = builtins.match regex1 fullString;
      registry = builtins.elemAt matches 1;
      scope = builtins.elemAt matches 3;
      nameVersionSuffix = builtins.elemAt matches 4;
      split = lib.strings.splitString "_" nameVersionSuffix;
      regex2 = "^(.*)@(.*)$";
      nameVersion = builtins.match regex2 (builtins.elemAt split 0);
      name = builtins.elemAt nameVersion 0;
      version = builtins.elemAt nameVersion 1;
      suffix =
        if ((builtins.length split) == 1) then
          null
        else
          (builtins.concatStringsSep "_" (lib.lists.drop 1 split));
    in
    {
      inherit
        fullString
        registry
        scope
        name
        version
        suffix
        ;
    };

  runTests =
    function: fixtures:
    builtins.map (
      t:
      (
        assert (function t.input) == t.expected;
        "success"
      )
    ) fixtures;

in
{
  inherit parsePackageSpecifier;
  tests = runTests parsePackageSpecifier fixtures;
}
