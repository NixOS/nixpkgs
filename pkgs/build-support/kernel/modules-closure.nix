# Given a kernel build (with modules in $kernel/lib/modules/VERSION),
# produce a module tree in $out/lib/modules/VERSION that contains only
# the modules identified by `rootModules', plus their dependencies.
# Also generate an appropriate modules.dep.

{
  buildPackages,
  kernel,
  firmware,
  nukeReferences,
  rootModules,
  kmod,
  allowMissing ? false,
  extraFirmwarePaths ? [ ],
}:

# `buildPackages.stdenvNoCC.mkDerivation` so the assembly derivation is
# built on the build platform; the script reads ELF metadata from kernel
# modules and emits text (modules.dep, symbol info), which is
# arch-independent. `kmod`/`nukeReferences` are listed as nativeBuildInputs
# and will be auto-spliced to their build-platform variants in cross builds.
# In native builds `buildPackages == self`, so the derivation is identical.
buildPackages.stdenvNoCC.mkDerivation {
  name = kernel.name + "-shrunk";
  builder = ./modules-closure.sh;
  nativeBuildInputs = [
    nukeReferences
    kmod
  ];
  inherit
    kernel
    firmware
    rootModules
    allowMissing
    extraFirmwarePaths
    ;
  allowedReferences = [ "out" ];
}
