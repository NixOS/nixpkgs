{
  lib,
  stdenv,
  writeTextFile,
  backends,
}:
let
  src = writeTextFile {
    name = "test.cpp";
    text = ''
      #include <sycl/sycl.hpp>
      #include <iostream>

      int main() {
        sycl::queue q;
        std::cout << "SYCL queue created successfully" << std::endl;
        return 0;
      }
    '';
  };

  # std::div and std::complex in a kernel need include/sycl/stl_wrappers
  # ahead of libstdc++. Otherwise the real <cstdlib> is used and the device
  # compiler rejects it as an undefined function.
  stlWrappersSrc = writeTextFile {
    name = "stl-wrappers.cpp";
    text = ''
      #include <sycl/sycl.hpp>
      #include <complex>
      #include <cstdlib>

      int main() {
        sycl::queue{}.single_task([] { (void)std::div(7, 3); });
        sycl::queue{}.parallel_for(sycl::nd_range<1>{1, 1}, [](sycl::nd_item<1> it) {
          (void)sycl::reduce_over_group(it.get_group(), std::complex<float>{}, sycl::plus<>());
        });
      }
    '';
  };

  targets = [
    # SPIR-V is a bit of a special case; it's always available
    # and needs no device libraries.
    {
      name = "spir64";
      flags = [ ];
      checkStlWrappers = true;
    }
    # ...unless the new offload driver is used, which links them at compile
    # time and errors out if they can't be found.
    {
      name = "spir64-new-offload-driver";
      flags = [ "--offload-new-driver" ];
    }
    # Same compile as spir64, with the setup hook's NIX_CFLAGS_COMPILE cleared.
    # libcxx-cxxflags has to provide <sycl/sycl.hpp> and <CL/cl.h> on its own.
    {
      name = "spir64-without-setup-cflags";
      flags = [ ];
      ignoreSetupHookCflags = true;
      checkStlWrappers = true;
    }
  ]
  ++ lib.optional (lib.elem "native_cpu" backends) {
    name = "native_cpu";
    flags = [ "-fsycl-targets=native_cpu" ];
  }
  ++ lib.optional (lib.elem "cuda" backends) {
    name = "nvptx64-nvidia-cuda";
    # Defaults to sm_75.
    flags = [ "-fsycl-targets=nvptx64-nvidia-cuda" ];
  }
  ++ lib.optional (lib.elem "hip" backends) {
    name = "amdgcn-amd-amdhsa";
    # AMD has no default arch, so we have to name one. It doesn't matter which,
    # as we only care that the device libraries are found at all.
    flags = [
      "-fsycl-targets=amdgcn-amd-amdhsa"
      "-Xsycl-target-backend=amdgcn-amd-amdhsa"
      "--offload-arch=gfx90a"
    ];
  };

  mkTest =
    {
      name,
      flags,
      ignoreSetupHookCflags ? false,
      checkStlWrappers ? false,
    }:
    stdenv.mkDerivation {
      name = "intel-llvm-test-sycl-compile-${name}";

      inherit src;

      dontUnpack = true;

      buildPhase = ''
        echo "Checking if a SYCL program can be built for ${name}..."
        ${lib.optionalString ignoreSetupHookCflags ''
          export NIX_CFLAGS_COMPILE=
          export NIX_CFLAGS_COMPILE_BEFORE=
        ''}
        clang++ -fsycl ${lib.escapeShellArgs flags} $src -o test
        ${lib.optionalString checkStlWrappers ''
          echo "Checking std::div and std::complex in a kernel for ${name}..."
          clang++ -fsycl ${lib.escapeShellArgs flags} ${stlWrappersSrc} -o stl-wrappers
        ''}
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp test $out/bin/sycl-test
      '';

      meta = {
        description = "Test that intel-llvm can build a SYCL program for ${name}";
        mainProgram = "sycl-test";
      };
    };
in
lib.listToAttrs (
  map (target: lib.nameValuePair "sycl-compile-${target.name}" (mkTest target)) targets
)
