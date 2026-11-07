{
  lib,
  rustPlatform,
  cmake,
  makeBinaryWrapper,
  pkg-config,
  cacert,
  fetchurl,
  jq,
  runCommand,
  mesh-llm,
  skippy-native-runtime,

  config,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}:

let
  # The same runtime bundles and environment as mesh-llm, which loads the same runtime.
  inherit (mesh-llm.override { inherit cudaSupport rocmSupport; })
    runtimeEnvironment
    runtimePrograms
    ;
in
# nixpkgs-update: no auto update
# mesh-llm's update script updates the release.
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "skippy-tools";

  __structuredAttrs = true;
  strictDeps = true;
  # Some tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;
  inherit (skippy-native-runtime) version;
  src = skippy-native-runtime.meshLlmSrc;
  inherit (mesh-llm) cargoDeps;

  postPatch = (mesh-llm.postPatch or "") + ''
    # As upstream's skippy-quantize-standalone-build (just/skippy.just): without
    # the dynamic runtime loader, linked against the runtime's llama.cpp.
    substituteInPlace skippy/crates/skippy-quantize/Cargo.toml \
      --replace-fail 'default = ["dynamic-skippy-runtime"]' 'default = []'
    # The dynamic link mode leaves out the ggml libraries that the static one
    # links, which skippy-ffi calls directly:
    # https://github.com/Mesh-LLM/mesh-llm/pull/2885.
    substituteInPlace skippy/crates/skippy-ffi/build/native_link.rs \
      --replace-fail 'println!("cargo:rustc-link-lib=dylib=llama");' \
                     'println!("cargo:rustc-link-lib=dylib=llama"); println!("cargo:rustc-link-lib=dylib=ggml"); println!("cargo:rustc-link-lib=dylib=ggml-base");'
  '';

  cargoBuildFlags = [
    "--package"
    "skippy-package-builder"
    "--package"
    "skippy-quantize"
    "--package"
    "llama-spec-bench"
    "--package"
    "skippy-correctness"
  ];

  cargoTestFlags = [
    "--package"
    "skippy-package-builder"
    "--package"
    "skippy-quantize"
    "--package"
    "llama-spec-bench"
    "--package"
    "skippy-correctness"
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
  ];

  # skippy-correctness's cache tests build an HTTP client, which can't be built
  # without CA roots (https://github.com/Mesh-LLM/mesh-llm/issues/2740).
  nativeCheckInputs = [ cacert ];

  buildInputs = [
    skippy-native-runtime
  ];

  env =
    runtimeEnvironment
    // (mesh-llm.env or { })
    // {
      SKIPPY_LLAMA_LINK_MODE = "dynamic";
      SKIPPY_LLAMA_LIB_DIR = "${skippy-native-runtime}/lib";
    };

  # cmake is only used by dependency build scripts
  dontUseCmakeConfigure = true;

  # As in mesh-llm: the tests find the CPU runtime here, and skippy-quantize's
  # tests read the quantization table of the pinned llama.cpp from .deps/llama.cpp.
  preCheck = ''
    export MESH_LLM_NATIVE_RUNTIME_BUNDLE_DIR=${skippy-native-runtime}/share/mesh-llm/runtimes
    mkdir -p .deps
    ln -s ${skippy-native-runtime.src} .deps/llama.cpp
  '';

  postInstall = ''
    for bin in skippy-package-builder skippy-quantize llama-spec-bench skippy-correctness; do
      wrapProgram "$out/bin/$bin" ${
        lib.escapeShellArgs (
          lib.concatLists (
            lib.mapAttrsToList (name: value: [
              "--set-default"
              name
              value
            ]) runtimeEnvironment
          )
          ++ lib.optionals (runtimePrograms != [ ]) [
            "--prefix"
            "PATH"
            ":"
            (lib.makeBinPath runtimePrograms)
          ]
        )
      }
    done
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    for bin in skippy-package-builder skippy-quantize llama-spec-bench skippy-correctness; do
      echo "checking $bin --help"
      "$out/bin/$bin" --help > /dev/null
    done
    runHook postInstallCheck
  '';

  passthru.tests = {
    model-tools =
      runCommand "skippy-tools-model-test"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
            jq
          ];
          model = fetchurl {
            url = "https://huggingface.co/ggml-org/models-moved/resolve/499bc8821c6b12b4e53c5bffcb21ec206f212d81/tinyllamas/stories260K.gguf";
            hash = "sha256-Jwy6G9UQn0LQM1D2BAYCRWBGTbFzwOOH2R8EJtO9JW0=";
          };
        }
        ''
          export HOME=$TMPDIR/home
          skippy-package-builder inspect "$model" | jq -e '.tensor_count == 48'
          skippy-quantize quantize "$model" Q8_0 --dry-run --work-dir "$TMPDIR/work"
          touch $out
        '';
  };

  meta = {
    description = "Model management, benchmarking, and quantization tools for Skippy and MeshLLM";
    longDescription = ''
      Operator and diagnostic tooling for Skippy model serving:
      - skippy-package-builder: inspects models and authors/verifies Skippy package manifests
      - skippy-quantize: converts and quantizes GGUF models
      - llama-spec-bench: checks speculative-decoding draft/target model pairs
      - skippy-correctness: validates split-layer distributed inference against monolithic execution
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm/tree/main/skippy";
    inherit (skippy-native-runtime.meta) changelog;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    inherit (skippy-native-runtime.meta) platforms;
  };
})
