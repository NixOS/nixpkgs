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
  # `lld` supports specifying the linker flavor with `-flavor` but requires that
  # this be the _first_ argument.
  flavorArgumentParsed = stdenvNoCC.mkDerivation {
    name = "bintools-wrapper-lld-flavor-arg-test";
    nativeBuildInputs = [ finalPackage ];
    buildCommand = ''
      # We expect `-flavor` to be moved before `--help`:
      NIX_LDFLAGS_BEFORE="--help" ld -flavor gnu \
        | grep "supported targets: elf"

      # If `-flavor` isn't the first arg the wrapper should not move it; i.e.
      # we expect the below to fail with an error about `-flavor`:
      { ld --gc-sections -flavor gnu || :; } \
        |& grep "unknown argument '-flavor'"

      # Note that we allow non-zero exit codes for the other linker flavors;
      # `ld-wrapper` still injects flags that don't account for the linker
      # flavor and so arg parsing fails on some hostPlatforms.

      # We should be able to specify the `link` flavor:
      { NIX_LDFLAGS_BEFORE="/help" ld -flavor link || :; } \
        | grep "Create a DLL"

      # `ld64`:
      { NIX_LDFLAGS_BEFORE="--help" ld -flavor ld64 || :; } \
        | grep "macos, ios"
    '' + lib.optionalString (lib.versionAtLeast "6.0.0" finalPackage.version) ''
      # wasm support was added to lld in v6.0:
      # https://github.com/llvm/llvm-project/commit/c94d393ad52b6698b15400ee7a33a68b4bda274b
      { NIX_LDFLAGS_BEFORE="--help" ld -flavor wasm || :; } \
        | grep "OVERVIEW: LLVM Linker"
    '' + ''
    '';
  };

  # The `lld` package exposes several linker symlinks for its various flavors
  # (`wasm-ld`, `ld64.lld`, `ld.lld`, `lld-link`) as well as an `lld` binary but
  # at the moment we only expose `ld.lld` (and `ld`, a symlink) so that's all
  # we test for here:
  ldVersion = testVersion { binaryName = "ld"; };
  ldLldVersion = testVersion { binaryName = "ld.lld"; };
}
