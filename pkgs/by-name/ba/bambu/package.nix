{
  stdenv,
  pkgsi686Linux,
  makeWrapper,
  lib,
  glibc,
  bambu-unwrapped,
  verilator,
  bash,
  gawk,
  coreutils,
  findutils,
  gnumake,
  gnused,
  gnugrep,
  verilog,
  which,
}:

stdenv.mkDerivation {
  pname = "bambu";
  inherit (bambu-unwrapped) meta version;

  nativeBuildInputs = [ makeWrapper ];

  doCheck = true;

  unpackPhase = ''
    # Test if this builds on ofborg with less cores
    # Setting this once in the overwritten unpackPhase should be enough but I want to make sure that this gets set in any case
    NIX_BUILD_CORES=4
    export NIX_BUILD_CORES=4

    #:
  '';

  buildPhase = ''
    runHook preBuild

    # Test if this builds on ofborg with less cores
    # Setting this once in the overwritten unpackPhase should be enough but I want to make sure that this gets set in any case
    NIX_BUILD_CORES=4
    export NIX_BUILD_CORES=4

    mkdir $out
    ln -s ${bambu-unwrapped}/* $out
    rm $out/bin
    mkdir $out/bin
    ln -s ${bambu-unwrapped}/bin/* $out/bin
    for f in $out/bin/*; do
      if [ -f "$f" ]; then
          wrapProgram "$f" \
            --suffix LDFLAGS " " "-L${glibc.static}/lib" \
            --set PATH ${
              lib.makeBinPath [
                pkgsi686Linux.gcc
                verilator
                bash
                gawk
                findutils
                coreutils
                gnumake
                gnused
                gnugrep
                verilog
                which
              ]
            }
      fi
    done

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    # Test if this builds on ofborg with less cores
    # Setting this once in the overwritten unpackPhase should be enough but I want to make sure that this gets set in any case
    NIX_BUILD_CORES=4
    export NIX_BUILD_CORES=4

    # Check that bambu can synthesize and verilate a simple program
    cat <<EOT >> min_max.cpp
    void min_max(int* numbers, int numbers_length, int* out_max, int* out_min)
    {
       int local_max = numbers[0];
       int local_min = numbers[0];
       int i = 0;
       for(i = 0; i < numbers_length; i++)
       {
          if(numbers[i] > local_max)
          {
             local_max = numbers[i];
          }
          if(numbers[i] < local_min)
          {
             local_min = numbers[i];
          }
       }
       *out_max = local_max;
       *out_min = local_min;
    }
    EOT
    cat <<EOT >> testbench.xml
    <?xml version="1.0"?>
    <function>
      <testbench numbers_length="5" numbers="{31, 73, 69, 54, 10}" out_max="{0}" out_min="{0}" />
    </function>
    EOT
    $out/bin/bambu min_max.cpp --top-fname=min_max --generate-tb=testbench.xml --simulate --simulator=VERILATOR -v4 --compiler=I386_CLANG16 -O5

    runHook postCheck
  '';
}
