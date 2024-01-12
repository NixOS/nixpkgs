{
  lib,
  runCommandLocal,
  nix,
}:

# Replace some direct dependencies of drv, not recursing into the dependency tree.
# You likely want to use replaceDependencies instead, unless you plan to implement your own recursion mechanism.
{ drv, replacements ? [ ] }:
let inherit (lib) all stringLength substring concatStringsSep;
in assert all ({ oldDependency, newDependency }:
  stringLength oldDependency == stringLength newDependency) replacements;
if replacements == [ ] then
  drv
else
  let drvName = substring 33 (stringLength (baseNameOf drv)) (baseNameOf drv);
  in runCommandLocal drvName { nixStore = "${nix}/bin/nix-store"; } ''
    $nixStore --dump ${drv} | sed 's|${
      baseNameOf drv
    }|'$(basename $out)'|g' | sed -e ${
      concatStringsSep " -e " (map ({ oldDependency, newDependency }:
        "'s|${baseNameOf oldDependency}|${baseNameOf newDependency}|g'")
        replacements)
    } | $nixStore --restore $out
  ''
