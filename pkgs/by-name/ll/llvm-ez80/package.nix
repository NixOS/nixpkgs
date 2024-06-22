{ stdenv, fetchFromGitHub, lib, cmake, python3 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "llvm-ez80";
  version = "0-unstable-2023-12-13";

  src = fetchFromGitHub {
    owner = "jacobly0";
    repo = "llvm-project";
    rev = "005a99ce2569373524bd881207aa4a1e98a2b238";
    hash = "sha256-g9AVQF48HvaOzwm6Fr935+2+Ch+nvUV2afygb3iUflw=";
  };

  configurePhase = ''
    mkdir build
    cd build
    cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=clang -DLLVM_TARGETS_TO_BUILD= -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=Z80
    cd ..
'';


  buildPhase = ''
    cd build
    cmake --build . --target clang llvm-link -j $NIX_BUILD_CORES
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/bin/clang $out/bin/ez80-clang
    cp build/bin/llvm-link $out/bin/ez80-link
  '';

  meta = {
    description = "A compiler and linker for (e)Z80 targets.";
    longDescription = ''
      This package provides a compiler and linker for (e)Z80 targets
      based on the LLVM toolchain.
      Originally designed for the TI-84 Plus CE, this also works for the Agon Light.

      This does not provide fasmg or any include files to build the programs.
      Please install a toolchain, such as the CE C toolchain.
    '';
    homepage = "https://github.com/jacobly0/llvm-project";
    license = lib.licenses.asl20-llvm;
    maintainers = with lib.maintainers; [ clevor ];
    platforms = lib.platforms.unix;
  };

  doCheck = false;

  nativeBuildInputs = [ cmake python3 ];

  # Optionally add fasmg as a runtime dependency.
  # If added, please update the package inputs and long description.
  # buildInputs = [ fasmg ];
})
