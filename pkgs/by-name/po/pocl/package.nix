{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hwloc,
  llvmPackages,
  libxml2, # required for statically linked llvm
  spirv-llvm-translator,
  spirv-tools,
  lttng-ust,
  opencl-headers,
  ocl-icd,
  python3,
  runCommand,
  makeWrapper,
  writableTmpDirAsHomeHook,
}:

let
  clang = llvmPackages.clangUseLLVM;
  # Workaround to make sure libclang finds libgcc.a and libgcc_s.so when
  # invoked from within libpocl
  clangWrapped =
    if stdenv.hostPlatform.isDarwin then
      clang
    else
      runCommand "clang-pocl" { nativeBuildInputs = [ makeWrapper ]; } ''
        mkdir -p $out/bin
        cp -r ${clang}/bin/* $out/bin/
        LIBGCC_DIR=$(dirname $(find ${stdenv.cc.cc}/lib/ -name libgcc.a))
        for F in ${clang}/bin/ld*; do
          BASENAME=$(basename "$F")
          rm -f $out/bin/$BASENAME
          makeWrapper ${clang}/bin/$BASENAME $out/bin/$BASENAME \
            --add-flags "-L$LIBGCC_DIR" \
            --add-flags "-L${lib.getLib stdenv.cc.cc}/lib"
        done
      '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pocl";
  version = "7.0-unstable-2025-09-30";

  src = fetchFromGitHub {
    owner = "pocl";
    repo = "pocl";
    rev = "f24d07da32bdd639538d3016cad2ab920cd16ce3";
    hash = "sha256-D7sMZ2B7Ex840ZhM07nrdnlek0HhI5GkvUNA4k5hsPk=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace pocld/shared_cl_context.cc --replace-fail \
      "Dev.getInfo<CL_DEVICE_GLOBAL_MEM_SIZE>()" \
      "static_cast<size_t>(Dev.getInfo<CL_DEVICE_GLOBAL_MEM_SIZE>())"
  '';

  cmakeFlags = [
    # avoid the runtime linker pulling in a different llvm e.g. from graphics drivers
    (lib.cmakeBool "STATIC_LLVM" true)
    (lib.cmakeBool "ENABLE_POCL_BUILDING" false)
    (lib.cmakeBool "POCL_ICD_ABSOLUTE_PATH" true)
    (lib.cmakeBool "ENABLE_ICD" true)
    (lib.cmakeBool "ENABLE_REMOTE_CLIENT" true)
    (lib.cmakeBool "ENABLE_REMOTE_SERVER" true)
    (lib.cmakeFeature "CLANG" "${clangWrapped}/bin/clang")
    (lib.cmakeFeature "CLANGXX" "${clangWrapped}/bin/clang++")
  ]
  # Only x86_64 supports "distro" which allows runtime detection of SSE/AVX
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    (lib.cmakeFeature "KERNELLIB_HOST_CPU_VARIANTS" "distro")
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [
    (lib.cmakeFeature "LLC_HOST_CPU" "generic")
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    clangWrapped
    python3
  ];

  buildInputs = [
    hwloc
    libxml2
    llvmPackages.llvm
    llvmPackages.libclang
    opencl-headers
    ocl-icd
    spirv-tools
    spirv-llvm-translator
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    lttng-ust
  ];

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    export OCL_ICD_VENDORS=$out/etc/OpenCL/vendors
    $out/bin/poclcc -o poclcc.cl.pocl $src/examples/poclcc/poclcc.cl

    runHook postInstallCheck
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Portable open source (MIT-licensed) implementation of the OpenCL standard";
    homepage = "https://portablecl.org";
    changelog = "https://github.com/pocl/pocl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jansol
      johnrtitor
      xddxdd
    ];
    platforms = lib.platforms.unix;
  };
})
