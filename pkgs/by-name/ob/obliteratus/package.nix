{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "obliteratus";
  version = "0-unstable-2026-06-17";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "elder-plinius";
    repo = "OBLITERATUS";
    rev = "a5a1ffa5849b442cf188b3c03fd4de71ddf5bdcc";
    hash = "sha256-IxIpUlVlZRzXan53mCCsH8AYg/ajNofSm56iUO9XPrg=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    accelerate
    bitsandbytes
    datasets
    matplotlib
    numpy
    pandas
    pyyaml
    rich
    safetensors
    scikit-learn
    seaborn
    torch
    tqdm
    transformers
  ];

  optional-dependencies = with python3Packages; {
    spaces = [ gradio ];
  };

  pythonImportsCheck = [ "obliteratus" ];

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTestPaths = [
    # These tests reference `obliteratus.models.loader._select_model_class`, which upstream
    # removed/renamed without updating the tests or the benchmark script.
    "tests/test_gemma4_hard_tier_bench.py"
    "tests/test_gemma4_support.py"
  ];

  disabledTests = [
    # Upstream tests that hardcode expectations the implementation has since outgrown
    # (e.g. 512 prompts vs the current 842, a stale method set, changed pipeline defaults).
    "test_default_values"
    "test_informed_method_in_abliterate_methods"
    "test_informed_method_standalone"
    "test_inherits_base_pipeline"
    "test_linear_cone_fewer_directions"
    "test_methods_exist"
    "test_prompt_count_512"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "test_output_dtype_preserved"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Ablation Suite for HuggingFace transformers";
    homepage = "https://github.com/elder-plinius/OBLITERATUS";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "obliteratus";
  };
})
