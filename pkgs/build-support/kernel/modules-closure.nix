# Given a kernel build (with modules in $kernel/lib/modules/VERSION),
# produce a module tree in $out/lib/modules/VERSION that contains only
# the modules identified by `rootModules', plus their dependencies.
# Also generate an appropriate modules.dep.

{ stdenv, kernel, nukeReferences, rootModules
, kmod, allowMissing ? false }:

stdenv.mkDerivation {
  name = kernel.name + "-shrunk";
  builder = ./modules-closure.sh;
  buildInputs = [ nukeReferences kmod ];
  inherit kernel rootModules allowMissing;
  allowedReferences = ["out"];
}
