# This needs to be run in a NixOS test, because Hydra cannot do IFD.
let
  pkgs = import ../../.. { };
  inherit (pkgs) lib;
  mkCheckOutput =
    name: test: output:
    pkgs.runCommand name { } ''
      actualOutput="$(${lib.escapeShellArg "${test}/bin/test"})"
      if [ "$(${lib.escapeShellArg "${test}/bin/test"})" != ${lib.escapeShellArg output} ]; then
        echo >&2 "mismatched output: expected \""${lib.escapeShellArg output}"\", got \"$actualOutput\""
        exit 1
      fi
      touch "$out"
    '';
  oldDependency = pkgs.writeShellScriptBin "dependency" ''
    echo "got old dependency"
  '';
  oldDependency-ca = oldDependency.overrideAttrs { __contentAddressed = true; };
  newDependency = pkgs.writeShellScriptBin "dependency" ''
    echo "got new dependency"
  '';
  newDependency-ca = newDependency.overrideAttrs { __contentAddressed = true; };
  basic = pkgs.writeShellScriptBin "test" ''
    ${oldDependency}/bin/dependency
  '';
  basic-ca = pkgs.writeShellScriptBin "test" ''
    ${oldDependency-ca}/bin/dependency
  '';
  transitive = pkgs.writeShellScriptBin "test" ''
    ${basic}/bin/test
  '';
  weirdDependency = pkgs.writeShellScriptBin "dependency" ''
    echo "got weird dependency"
    ${basic}/bin/test
  '';
  oldDependency1 = pkgs.writeShellScriptBin "dependency1" ''
    echo "got old dependency 1"
  '';
  newDependency1 = pkgs.writeShellScriptBin "dependency1" ''
    echo "got new dependency 1"
  '';
  oldDependency2 = pkgs.writeShellScriptBin "dependency2" ''
    ${oldDependency1}/bin/dependency1
      echo "got old dependency 2"
  '';
  newDependency2 = pkgs.writeShellScriptBin "dependency2" ''
    ${oldDependency1}/bin/dependency1
      echo "got new dependency 2"
  '';
  deep = pkgs.writeShellScriptBin "test" ''
    ${oldDependency2}/bin/dependency2
  '';
in
{
  replacedependency-basic = mkCheckOutput "replacedependency-basic" (pkgs.replaceDependency {
    drv = basic;
    inherit oldDependency newDependency;
  }) "got new dependency";

  replacedependency-basic-old-ca = mkCheckOutput "replacedependency-basic" (pkgs.replaceDependency {
    drv = basic-ca;
    oldDependency = oldDependency-ca;
    inherit newDependency;
  }) "got new dependency";

  replacedependency-basic-new-ca = mkCheckOutput "replacedependency-basic" (pkgs.replaceDependency {
    drv = basic;
    inherit oldDependency;
    newDependency = newDependency-ca;
  }) "got new dependency";

  replacedependency-transitive = mkCheckOutput "replacedependency-transitive" (pkgs.replaceDependency {
    drv = transitive;
    inherit oldDependency newDependency;
  }) "got new dependency";

  replacedependency-weird =
    mkCheckOutput "replacedependency-weird"
      (pkgs.replaceDependency {
        drv = basic;
        inherit oldDependency;
        newDependency = weirdDependency;
      })
      ''
        got weird dependency
        got old dependency'';

  replacedependencies-precedence = mkCheckOutput "replacedependencies-precedence" (pkgs.replaceDependencies
    {
      drv = basic;
      replacements = [ { inherit oldDependency newDependency; } ];
      cutoffPackages = [ oldDependency ];
    }
  ) "got new dependency";

  replacedependencies-self = mkCheckOutput "replacedependencies-self" (pkgs.replaceDependencies {
    drv = basic;
    replacements = [
      {
        inherit oldDependency;
        newDependency = oldDependency;
      }
    ];
  }) "got old dependency";

  replacedependencies-deep-order1 =
    mkCheckOutput "replacedependencies-deep-order1"
      (pkgs.replaceDependencies {
        drv = deep;
        replacements = [
          {
            oldDependency = oldDependency1;
            newDependency = newDependency1;
          }
          {
            oldDependency = oldDependency2;
            newDependency = newDependency2;
          }
        ];
      })
      ''
        got new dependency 1
        got new dependency 2'';

  replacedependencies-deep-order2 =
    mkCheckOutput "replacedependencies-deep-order2"
      (pkgs.replaceDependencies {
        drv = deep;
        replacements = [
          {
            oldDependency = oldDependency2;
            newDependency = newDependency2;
          }
          {
            oldDependency = oldDependency1;
            newDependency = newDependency1;
          }
        ];
      })
      ''
        got new dependency 1
        got new dependency 2'';
}
