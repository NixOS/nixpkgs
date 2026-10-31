{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  version,
  src,
  meta,
  sources,
}:

# Analysis model runtime, upstream builds it in build/buildMnnRuntime.mjs
stdenv.mkDerivation (finalAttrs: {
  pname = "folia-mnn";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/native/folia-mnn";

  # Fail early when sources.json is stale; regenerate it with update.sh
  postPatch = ''
    grep -qF "MNN_COMMIT = '${finalAttrs.passthru.mnnSrc.rev}'" ../../build/buildMnnRuntime.mjs
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeFeature "MNN_SOURCE_DIR" "${finalAttrs.passthru.mnnSrc}")
    # Downloaded at configure time, and only used with the CPU_ENABLE_KLEIDIAI hint folia never sets
    (lib.cmakeBool "MNN_KLEIDIAI" false)
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 libfolia_mnn${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib
    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  passthru.mnnSrc = fetchFromGitHub {
    owner = "alibaba";
    repo = "MNN";
    inherit (sources.mnn) rev hash;
  };

  meta =
    removeAttrs meta [
      "mainProgram"
      "sourceProvenance"
    ]
    // {
      description = "MNN based audio analysis runtime of Folia";
      homepage = "https://github.com/chthollyphile/folia-major/tree/${finalAttrs.src.tag}/native/folia-mnn";
      license = with lib.licenses; [
        agpl3Only
        # MNN
        asl20
      ];
    };
})
