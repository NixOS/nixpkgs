{ lib, runCommand, testers }:

package:

runCommand "check-meta-pkg-config-modules-for-${package.name}" {
  meta = {
    description = "Test whether ${package.name} exposes all pkg-config modules ${toString package.meta.pkgConfigModules}";
  };
  dependsOn = testers.hasPkgConfigModules { inherit package; };
} ''
  echo "found all of ${toString package.meta.pkgConfigModules}" > "$out"
''
