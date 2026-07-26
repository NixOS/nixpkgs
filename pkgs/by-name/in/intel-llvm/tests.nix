{
  stdenv,
  writeTextFile,
}:
{
  sycl-compile = stdenv.mkDerivation {
    name = "intel-llvm-test-sycl-compile";

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

    dontUnpack = true;

    buildPhase = ''
      echo "Checking if a basic SYCL program can compile..."
      clang++ -fsycl $src -o test
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp test $out/bin/sycl-test
    '';

    meta = {
      description = "Test that intel-llvm can compile a basic SYCL program";
    };
  };
}
