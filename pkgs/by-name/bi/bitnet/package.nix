{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  makeBinaryWrapper,
  python3,
  # any
  enableImpureNativeOptimizations ? false,
  # x86
  enableAvx ? stdenv.hostPlatform.avxSupport,
  enableAvx2 ? stdenv.hostPlatform.avx2Support,
  enableFma ? stdenv.hostPlatform.fmaSupport,
  enableF16c ? stdenv.hostPlatform.avxSupport, # approximation with some false negatives
  enableAvx512 ? stdenv.hostPlatform.avx512Support,
  enableAvx512VBMI ? false,
  enableAvx512VNNI ? false,
  enableAvx512BF16 ? false,
  # arm
  enableSve ? false,
  # model selection
  modelName ? "microsoft/BitNet-b1.58-2B-4T",
  modelRepo ? fetchurl {
    url = "https://huggingface.co/microsoft/bitnet-b1.58-2B-4T-gguf/resolve/de6ce176e062a4c6ba0162824474c4f07490b59c/ggml-model-i2_s.gguf";
    hash = "sha256-QiGyUv3V/SXhWEet/rXuiIhlBrpQuKNFSDdEkohMIWI=";
  },
}:

let
  x86 = stdenv.hostPlatform.isx86_64;
  arm = stdenv.hostPlatform.isAarch64;
in

assert x86 || arm;

stdenv.mkDerivation (finalAttrs: {
  pname = "bitnet";
  version = "0-unstable-2025-05-08";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "BitNet";
    rev = "c9e752c9d705fbbbdca474a9ce8e112bde9cc8e0";
    hash = "sha256-75EnSLq3XVbFB2X/B2/HgmknGgw0Bj29KXamu48VUS4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    python3
  ];

  postPatch = ''
    substituteInPlace setup_env.py \
      --replace-fail '    setup_gguf()' "    print('skipped setup_gguf')" \
      --replace-fail '    compile()' "    print('skipped compile')" \
      --replace-fail '    prepare_model()' "    print('skipped prepare_model')"
  '';

  preConfigure = ''
    python3 ./setup_env.py --hf-repo "${modelName}"
  '';

  cmakeFlags =
    [
      (lib.cmakeBool "BITNET_ARM_TL1" arm)
      (lib.cmakeBool "BITNET_X86_TL2" x86)
      (lib.cmakeBool "GGML_BITNET_ARM_TL1" arm)
      (lib.cmakeBool "GGML_BITNET_X86_TL2" x86)
      # loongarch64 related
      (lib.cmakeBool "GGML_LASX" false)
      (lib.cmakeBool "GGML_LSX" false)
      # catch-all
      (lib.cmakeBool "GGML_NATIVE" (!(finalAttrs.NIX_ENFORCE_NO_NATIVE or true)))
    ]
    ++ lib.optionals (finalAttrs.NIX_ENFORCE_NO_NATIVE or true) [
      # x86 related
      (lib.cmakeBool "GGML_AVX" enableAvx)
      (lib.cmakeBool "GGML_AVX2" enableAvx2)
      (lib.cmakeBool "GGML_AVX512" enableAvx512)
      (lib.cmakeBool "GGML_AVX512_VBMI" enableAvx512VBMI)
      (lib.cmakeBool "GGML_AVX512_VNNI" enableAvx512VNNI)
      (lib.cmakeBool "GGML_AVX512_BF16" enableAvx512BF16)
      (lib.cmakeBool "GGML_FMA" enableFma)
      (lib.cmakeBool "GGML_F16C" enableF16c)
      # arm related
      (lib.cmakeBool "GGML_SVE" enableSve)
    ];

  NIX_ENFORCE_NO_NATIVE = !enableImpureNativeOptimizations;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp bin/llama-cli $out/bin
    cp 3rdparty/llama.cpp/ggml/src/libggml.so $out/lib
    cp 3rdparty/llama.cpp/src/libllama.so $out/lib

    patchelf --add-rpath $out/lib $out/bin/llama-cli
    patchelf --shrink-rpath --allowed-rpath-prefixes ${builtins.storeDir} $out/lib/* $out/bin/*
    wrapProgram $out/bin/llama-cli \
      --add-flags "-m ${modelRepo}"

    runHook postInstall
  '';

  meta = {
    description = "Microsoft's inference framework for 1-bit LLMs";
    homepage = "https://github.com/microsoft/BitNet";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.fliegendewurst ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    broken =
      !(enableImpureNativeOptimizations || (x86 -> enableAvx) || arm)
      && (
        !config.allowAliases
        || (lib.assertMsg false "bitnet must be built with with AVX support on x86 (`enableAvx = true;`), or with impure native optimizations (`enableImpureNativeOptimizations = true;`)")
      );
  };
})
