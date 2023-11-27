# Given a kernel build (with modules in $kernel/lib/modules/VERSION),
# produce a module tree in $out/lib/modules/VERSION that contains only
# the modules identified by `rootModules', plus their dependencies.
# Also generate an appropriate modules.dep.

{ stdenvNoCC, kernel, firmware, rootModules
, kmod, allowMissing ? false
, copy-modules-closure, nukeReferences }:

stdenvNoCC.mkDerivation {
  name = kernel.name + "-shrunk";
  builder = ./modules-closure.sh;
  nativeBuildInputs = [ kmod copy-modules-closure nukeReferences ];
  inherit kernel firmware rootModules allowMissing;
  allowedReferences = ["out"];
}
