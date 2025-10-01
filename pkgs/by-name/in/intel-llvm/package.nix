{
  callPackage,
  wrapCC,
  symlinkJoin,
  overrideCC,
}:
let
  llvm-unwrapped = callPackage ./unwrapped.nix { };
  llvm-wrapper = (wrapCC llvm-unwrapped).overrideAttrs (old: {
    # OpenCL needs to be passed through
    propagatedBuildInputs = old.propagatedBuildInputs ++ llvm-unwrapped.propagatedBuildInputs;
  });
  # We merge everything into one by default to avoid issues with path-lookup.
  # intel-llvm provides the SYCL library, so unlike regular LLVM libraries,
  # its libraries are equally important as the compiler itself.
  llvm = symlinkJoin {
    inherit (llvm-unwrapped) pname version meta;

    paths = [
      # Order is important, we want files from the wrapper to take precedence
      llvm-wrapper
      llvm-unwrapped

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
