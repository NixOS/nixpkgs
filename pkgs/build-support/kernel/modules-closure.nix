# Given a kernel build (with modules in $kernel/lib/modules/VERSION),
# produce a module tree in $out/lib/modules/VERSION that contains only
# the modules identified by `rootModules', plus their dependencies.
# Also generate an appropriate modules.dep.

{ stdenv, kernel, nukeReferences, rootModules
, module_init_tools, allowMissing ? false }:

stdenv.mkDerivation {
  name = kernel.name + "-shrunk";
  builder = ./modules-closure.sh;
  buildInputs = [nukeReferences];
  inherit kernel rootModules module_init_tools allowMissing;
  allowedReferences = ["out"];
}
