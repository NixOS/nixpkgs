{ stdenv, fetchFromGitHub, cmake
, cudatoolkit, boost }:
let rev = "0.4b";
    sha256 = "0825kspi1fjr5w4rpp7ay8fcsi7idl8abrgf2l51q6jwxippw49y";
in stdenv.mkDerivation {
  name = "nheqminer-${rev}";
  src = fetchFromGitHub {
    owner = "nicehash";
    repo = "nheqminer";
    inherit rev sha256;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    cudatoolkit boost
  ];

  buildCommand = ''
    set -e
    unpackPhase
    echo "Building on $NIX_BUILD_CORES cores in"
    (cd $sourceRoot/cpu_xenoncat/Linux/asm
     ./assemble.sh)
    (cd $sourceRoot/Linux_cmake/nheqminer_cpu_xenoncat
     cmake .
     make -j$NIX_BUILD_CORES)
    (cd $sourceRoot/Linux_cmake/nheqminer_cuda_tromp
     cmake .
     make -j$NIX_BUILD_CORES)
    mkdir -p $out/bin
    cp $sourceRoot/Linux_cmake/nheqminer_cpu_xenoncat/nheqminer_cpu_xenoncat $sourceRoot/Linux_cmake/nheqminer_cuda_tromp/nheqminer_cuda_tromp $out/bin
  '';

}
