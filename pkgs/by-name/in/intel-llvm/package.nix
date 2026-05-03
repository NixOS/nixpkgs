{
  callPackage,
  newScope,
  wrapCCWith,
  symlinkJoin,
  overrideCC,
  lib,
  fetchFromGitHub,
}:
let
  # This derivation uses makeScope to help with overriding.
  #
  # To override the source and other basics:
  #  pkgs.intel-llvm.overrideScope (final: prev: {
  #    version = ..;
  #    src = ..;
  #    # If setting src, you'll probably also want to set this.
  #    commitDate = ..;
  #  })
  #
  # To override something inside unified-runtime:
  #  pkgs.intel-llvm.overrideScope (final: prev: {
  #    make-unified-runtime = args: (prev.make-unified-runtime args)
  #      .override { .. }
  #      .overrideAttrs { .. }
  #  })
  #
  # Note that this package does not support cross-compilation at the moment.
  #
  # TODO: Support cross
  #  The easiest path for this will likely be to use standalone packaging,
  #  and use the existing LLVM derivation with overrides. Though that won't
  #  be very workable until upstream support for standalone improves,
  #  see https://github.com/intel/llvm/issues/21877 for that.
  #
  #  Due to the multi-stage build, at several times during compilation
  #  the package runs binaries that were just compiled, and for cross these
  #  would need to be compiled for the host and not target platform,
  #  which is non-trivial to configure.
  scope = lib.makeScope newScope (self: {
    # == Parameters for overriding ==

    llvmMajorVersion = "22";

    version = "unstable-2025-11-14";

    src = fetchFromGitHub {
      owner = "intel";
      repo = "llvm";
      # Latest commit which doesn't require dependency versions newer than
      # what's available in nixpkgs as of 2026-01-13.
      # Commits after require newer level-zero and pre-release unified memory framework.
      rev = "ab3dc98de0fd1ada9df12b138de1e1f8b715cc27";
      hash = "sha256-oHk8kQVNsyC9vrOsDqVoFLYl2yMMaTgpQnAW9iHZLfE=";
    };

    # If you override src, you'll probably also want to override this,
    # as some packages check for this date to decide what features the compiler supports
    commitDate = "20251114";

    vc-intrinsics-src = fetchFromGitHub {
      owner = "intel";
      repo = "vc-intrinsics";
      # See llvm/lib/SYCLLowerIR/CMakeLists.txt:17
      rev = "60cea7590bd022d95f5cf336ee765033bd114d69";
      sha256 = "sha256-1K16UEa6DHoP2ukSx58OXJdtDWyUyHkq5Gd2DUj1644=";
    };

    # ===============================

    make-unified-runtime =
      {
        levelZeroSupport,
        cudaSupport,
        rocmSupport,
        rocmGpuTargets,
        nativeCpuSupport,
      }:
      callPackage ./unified-runtime.nix {
        intel-llvm-src = self.src;
        inherit
          levelZeroSupport
          cudaSupport
          rocmSupport
          rocmGpuTargets
          nativeCpuSupport
          ;
        # This could theoretically be disabled if you for some reason
        # didn't want to build the backend, however OpenCL will get
        # pulled in as a dependency either way so there is little point.
        openclSupport = true;
      };

    unwrapped = callPackage ./unwrapped.nix {
      inherit (self)
        llvmMajorVersion
        src
        version
        commitDate
        vc-intrinsics-src
        make-unified-runtime
        ;
    };

    wrapper = wrapCCWith {
      cc = self.unwrapped;
      # This is needed for tools like clang-scan-deps to find headers.
      # The build commands here are the same as the vanilla LLVM derivation.
      extraBuildCommands = ''
        rsrc="$out/resource-root"
        mkdir "$rsrc"
        echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
        ln -s "${lib.getLib self.unwrapped}/lib/clang/${self.llvmMajorVersion}/include" "$rsrc"
      '';

      extraPackages =
        # We need to explicitly link to the dev package to get headers like sycl.hpp
        [ self.unwrapped.dev ] # TODO: This needs to be from targetPackages once the package gets cross support
        # OpenCL and such need to be passed through
        ++ self.unwrapped.propagatedBuildInputs;
    };

    clang-tools-wrapper = callPackage ./clang-tools.nix {
      inherit (self) unwrapped wrapper;
    };

    # We merge everything into one by default to avoid issues with path-lookup.
    # intel-llvm provides the SYCL library, so unlike regular LLVM libraries,
    # its libraries are equally important as the compiler itself.
    # Splitting is nonetheless important, as otherwise the binaries go over the Hydra limit.
    merged = symlinkJoin {
      inherit (self.unwrapped) pname version meta;

      strictDeps = true;
      # Currently broken for symlinkJoin, can be removed once the following
      # reaches branch master:
      # https://github.com/NixOS/nixpkgs/pull/510526
      __structuredAttrs = false;

      paths = with self; [
        # Order is important, we want files from the wrappers to take precedence
        wrapper
        clang-tools-wrapper

        unwrapped.out
        unwrapped.dev
        unwrapped.lib
      ];

      passthru = self.unwrapped.passthru // {
        inherit (self) stdenv;
        unwrapped = self.unwrapped;
        tests = callPackage ./tests.nix { inherit (self) stdenv; };

        overrideScope = newF: (self.overrideScope newF).merged;
      };
    };
    stdenv = overrideCC self.unwrapped.baseLlvm.stdenv self.merged;
  });
in
scope.merged
