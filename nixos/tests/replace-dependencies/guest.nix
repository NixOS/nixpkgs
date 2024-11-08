# This needs to be run in a NixOS test, because Hydra cannot do IFD.
let
  pkgs = import ../../.. { };
  inherit (pkgs)
    runCommand
    writeShellScriptBin
    replaceDependency
    replaceDependencies
    ;
  inherit (pkgs.lib) escapeShellArg;
  mkCheckOutput =
    name: test: output:
    runCommand name { } ''
      actualOutput="$(${escapeShellArg "${test}/bin/test"})"
      if [ "$(${escapeShellArg "${test}/bin/test"})" != ${escapeShellArg output} ]; then
        echo >&2 "mismatched output: expected \""${escapeShellArg output}"\", got \"$actualOutput\""
        exit 1
      fi
      touch "$out"
    '';
  oldDependency = writeShellScriptBin "dependency" ''
    echo "got old dependency"
  '';
  oldDependency-ca = oldDependency.overrideAttrs { __contentAddressed = true; };
  newDependency = writeShellScriptBin "dependency" ''
    echo "got new dependency"
  '';
  newDependency-ca = newDependency.overrideAttrs { __contentAddressed = true; };
  basic = writeShellScriptBin "test" ''
    ${oldDependency}/bin/dependency
  '';
  basic-ca = writeShellScriptBin "test" ''
    ${oldDependency-ca}/bin/dependency
  '';
  transitive = writeShellScriptBin "test" ''
    ${basic}/bin/test
  '';
  weirdDependency = writeShellScriptBin "dependency" ''
    echo "got weird dependency"
    ${basic}/bin/test
  '';
  oldDependency1 = writeShellScriptBin "dependency1" ''
    echo "got old dependency 1"
  '';
  newDependency1 = writeShellScriptBin "dependency1" ''
    echo "got new dependency 1"
  '';
  oldDependency2 = writeShellScriptBin "dependency2" ''
    ${oldDependency1}/bin/dependency1
      echo "got old dependency 2"
  '';
  newDependency2 = writeShellScriptBin "dependency2" ''
    ${oldDependency1}/bin/dependency1
      echo "got new dependency 2"
  '';
  deep = writeShellScriptBin "test" ''
    ${oldDependency2}/bin/dependency2
  '';
in
{
  replacedependency-basic = mkCheckOutput "replacedependency-basic" (replaceDependency {
    drv = basic;
    inherit oldDependency newDependency;
  }) "got new dependency";

  replacedependency-basic-old-ca = mkCheckOutput "replacedependency-basic" (replaceDependency {
    drv = basic-ca;
    oldDependency = oldDependency-ca;
    inherit newDependency;
  }) "got new dependency";

  replacedependency-basic-new-ca = mkCheckOutput "replacedependency-basic" (replaceDependency {
    drv = basic;
    inherit oldDependency;
    newDependency = newDependency-ca;
  }) "got new dependency";

  replacedependency-transitive = mkCheckOutput "replacedependency-transitive" (replaceDependency {
    drv = transitive;
    inherit oldDependency newDependency;
  }) "got new dependency";

  replacedependency-weird =
    mkCheckOutput "replacedependency-weird"
      (replaceDependency {
        drv = basic;
        inherit oldDependency;
        newDependency = weirdDependency;
      })
      ''
        got weird dependency
        got old dependency'';

  replacedependencies-precedence = mkCheckOutput "replacedependencies-precedence" (replaceDependencies
    {
      drv = basic;
      replacements = [ { inherit oldDependency newDependency; } ];
      cutoffPackages = [ oldDependency ];
    }
  ) "got new dependency";

  replacedependencies-self = mkCheckOutput "replacedependencies-self" (replaceDependencies {
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
      (replaceDependencies {
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
      (replaceDependencies {
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
