# Given a kernel build (with modules in $kernel/lib/modules/VERSION),
# produce a module tree in $out/lib/modules/VERSION that contains only
# the modules identified by `rootModules', plus their dependencies.
# Also generate an appropriate modules.dep.

{
  stdenvNoCC,
  kernel,
  firmware,
  nukeReferences,
  rootModules,
  kmod,
  allowMissing ? false,
  extraFirmwarePaths ? [ ],
}:

stdenvNoCC.mkDerivation {
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
