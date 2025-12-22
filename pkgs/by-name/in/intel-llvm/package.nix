{
  callPackage,
  wrapCCWith,
  symlinkJoin,
  overrideCC,
  lib,
}:
let
  llvm-unwrapped = callPackage ./unwrapped.nix { };

  inherit (llvm-unwrapped) llvmMajorVersion;
  llvm-wrapper =
    (wrapCCWith {
      cc = llvm-unwrapped;
      # This is needed for tools like clang-scan-deps to find headers.
      # The build commands here are the same as the vanilla LLVM derivation.
      extraBuildCommands = ''
        rsrc="$out/resource-root"
        mkdir "$rsrc"
        echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
        ln -s "${lib.getLib llvm-unwrapped}/lib/clang/${llvmMajorVersion}/include" "$rsrc"
      '';
    }).overrideAttrs
      (old: {
        # OpenCL needs to be passed through
        propagatedBuildInputs = old.propagatedBuildInputs ++ llvm-unwrapped.propagatedBuildInputs;
      });
  clang-tools-wrapper = callPackage ./clang-tools.nix {
    inherit llvm-unwrapped llvm-wrapper;
  };

  # We merge everything into one by default to avoid issues with path-lookup.
  # intel-llvm provides the SYCL library, so unlike regular LLVM libraries,
  # its libraries are equally important as the compiler itself.
  llvm = symlinkJoin {
    inherit (llvm-unwrapped) pname version meta;

    paths = [
      # Order is important, we want files from the wrappers to take precedence
      llvm-wrapper
      clang-tools-wrapper

      llvm-unwrapped.out
      llvm-unwrapped.dev
      llvm-unwrapped.lib
    ];

    passthru = llvm-unwrapped.passthru // {
      inherit stdenv;
      unwrapped = llvm-unwrapped;
      tests = callPackage ./tests.nix { inherit stdenv; };
    };
  };
  stdenv = overrideCC llvm-unwrapped.baseLlvm.stdenv llvm;
in
llvm
