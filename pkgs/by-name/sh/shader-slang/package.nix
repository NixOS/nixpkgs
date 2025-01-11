{ lib, stdenv, fetchFromGitHub, cmake, python3, llvmPackages_13, xorg, }:
stdenv.mkDerivation (finalAttrs: {
  name = "shader-slang";
  version = "v2025.1";
  nativeBuildInputs = [ cmake python3 ];
  buildInputs =
    [ llvmPackages_13.libllvm llvmPackages_13.clang-unwrapped xorg.libX11 ];
  src = fetchFromGitHub {
    owner = "shader-slang";
    repo = "slang";
    rev = finalAttrs.version;
    hash = "sha256-uTf2GOEaqcZ8ZKGBFit5UU1JycMLYpKSq0Zvxxct+JI=";
    fetchSubmodules = true;
  };
  cmakeFlags = [ "-DSLANG_SLANG_LLVM_FLAVOR=USE_SYSTEM_LLVM" ];
  meta = with lib; {
    description = "The Slang Shading Language and Compiler";
    longDescription = ''
      The Slang shading language and compiler is a proven open-source technology
      empowering real-time graphics developers with flexible, innovative
      features that complement existing shading languages, including neural
      computation inside graphics shaders. Slang’s support for modular code
      significantly simplifies the development and maintenance of large
      codebases, while its compiler enables smooth migration paths for existing
      HLSL and GLSL shaders. The Slang compiler also supports multiple backend
      targets for portable code deployment across diverse APIs and platforms.
    '';
    homepage = "https://shader-slang.com/";
    license = licenses.asl20-llvm;
    mainProgram = "slangc";
    platforms = platforms.all;
    maintainers = with maintainers; [ expenses ];
  };
})
