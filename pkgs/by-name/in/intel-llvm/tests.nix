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

  targets = [
    # SPIR-V is a bit of a special case; it's always available
    # and needs no device libraries.
    {
      name = "spir64";
      flags = [ ];
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
    { name, flags }:
    stdenv.mkDerivation {
      name = "intel-llvm-test-sycl-compile-${name}";

      inherit src;

      dontUnpack = true;

      buildPhase = ''
        echo "Checking if a SYCL program can be built for ${name}..."
        clang++ -fsycl ${lib.escapeShellArgs flags} $src -o test
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
