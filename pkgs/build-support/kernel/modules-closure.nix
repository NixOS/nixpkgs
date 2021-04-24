# Given a kernel build (with modules in $kernel/lib/modules/VERSION),
# produce a module tree in $out/lib/modules/VERSION that contains only
# the modules identified by `rootModules', plus their dependencies.
# Also generate an appropriate modules.dep.

{ stdenvNoCC, kernel, firmware, nukeReferences, rootModules
, kmod, allowMissing ? false }:

stdenvNoCC.mkDerivation {
  name = kernel.name + "-shrunk";
  buildCommand = builtins.readFile ./modules-closure.sh;
  nativeBuildInputs = [ nukeReferences kmod ];
  inherit rootModules;
  env = {
    kernel = "${kernel}";
    firmware = "${firmware}";
    inherit allowMissing;
  };
  allowedReferences = ["out"];
}
