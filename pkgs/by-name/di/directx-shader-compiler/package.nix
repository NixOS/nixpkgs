{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  git,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "directx-shader-compiler";
  version = "1.9.2602";

  # Put headers in dev, there are lot of them which aren't necessary for
  # using the compiler binary.
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXShaderCompiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S3ar1LTV/9fYU2B5y8x0ESB20lMnAx8XQw9n3G4z0nk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    git
    ninja
    python3
  ];

  cmakeFlags = [
    "-C../cmake/caches/PredefinedParams.cmake"
    # Tries to download prebuilt dxcs
    (lib.cmakeBool "LLVM_INCLUDE_TESTS" false)
    (lib.cmakeBool "HLSL_INCLUDE_TESTS" false)
  ];

  # The default install target installs heaps of LLVM stuff.
  #
  # Upstream issue: https://github.com/microsoft/DirectXShaderCompiler/issues/3276
  #
  # The following is based on the CI script:
  # https://github.com/microsoft/DirectXShaderCompiler/blob/master/appveyor.yml#L63-L66
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib $dev/include
    mv bin/{dxc,dxv}* $out/bin/
    mv lib/lib*.so* lib/lib*.*dylib $out/lib/
    cp -r $src/include/dxc $dev/include/
    runHook postInstall
  '';

  meta = {
    description = "Compiler to compile HLSL programs into DXIL and SPIR-V";
    homepage = "https://github.com/microsoft/DirectXShaderCompiler";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ Flakebi ];
  };
})
