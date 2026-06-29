# Given a kernel build (with modules in $kernel/lib/modules/VERSION),
# produce a module tree in $out/lib/modules/VERSION that contains only
# the modules identified by `rootModules', plus their dependencies.
# Also generate an appropriate modules.dep.

{
  stdenvNoCC,
  kmod,
  nukeReferences,

  # Public API arguments

  # A build output with `lib/modules` from which `rootModules` will be picked.
  # NOTE: Do not use a NixOS kernel package!
  # The NixOS kernel packages expose their modules in a split output (`modules`).
  kernel,
  # A build output with `lib/firmware/` from which `extraFirmwarePaths` will be picked.
  firmware,
  # Modules that are required (unless allowMissing is used) to be added in the closure.
  # Their dependencies will also be added.
  rootModules,
  # When `true`, missing modules won't fail the build.
  allowMissing ? false,
  # When `true`, an empty output won't fail the build.
  allowEmpty ? false,
  # A list of firmware paths to be included in the closure.
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
    allowEmpty
    extraFirmwarePaths
    ;
  allowedReferences = [ "out" ];
}
