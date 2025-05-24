{
  lib,
  runCommand,
  testers,
}:

package:

runCommand "check-meta-cmake-config-modules-for-${package.name}"
  {
    meta = {
      description = "Test whether ${package.name} exposes all cmake-config modules ${toString package.meta.cmakeConfigModules}";
    };
    dependsOn = testers.hasCmakeConfigModules { inherit package; };
  }
  ''
    echo "found all of ${toString package.meta.cmakeConfigModules}" > "$out"
  ''
