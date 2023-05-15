{ stdenvNoCC
, lib
, finalPackage
, testers
}: let
  testVersion = { binaryName }: testers.testVersion {
    package = finalPackage;
    command = "${binaryName} --version";
  };
in lib.optionalAttrs finalPackage.isLLVM {
  # The `lld` package exposes several linker symlinks for its various flavors
  # (`wasm-ld`, `ld64.lld`, `ld.lld`, `lld-link`) as well as an `lld` binary but
  # at the moment we only expose `ld.lld` (and `ld`, a symlink) so that's all
  # we test for here:
  ldVersion = testVersion { binaryName = "ld"; };
  ldLldVersion = testVersion { binaryName = "ld.lld"; };
}
