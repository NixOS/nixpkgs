{
  lib,
  buildPythonPackage,
  cudaPackages,
  writeShellApplication,

  # build-system
  setuptools,

  # dependencies
  apache-tvm-ffi,
  networkx,
  nvidia-cutlass-dsl,

  # optional-dependencies
  nvidia-matmul-heuristics,
  torch,
  torch-c-dlpack-ext,

  # tests
  pytestCheckHook,
}:

let
  # Import jax, which is left out of the optional-dependencies
  jaxTestPaths = [
    "test/unit/test_reference_check.py"
    "test/integration/test_gemm_jax.py"
  ];

  # Unit tests needing a GPU; passthru.gpuCheck runs them, along with the integration tests
  gpuTests = [
    # test/unit/test_allocation.py: allocate CUDA tensors
    "test_distinct_operands_do_not_share_storage"
    "test_distinct_operands_hold_different_data"
    "test_operands_are_uncorrelated_enough_for_exact_accumulation"
    "test_buffer_over_allocates_by_the_offset_bound_not_by_double"
    "test_random_offset_is_bounded_but_still_varies"
    "test_buffer_spans_the_tensor_without_double_counting"
    "test_seed_collision_is_reported_not_silently_accepted"
    # test/unit/test_metadata.py: allocate CUDA tensors
    "test_perfectly_aligned"
    "test_overaligned"
    "test_underaligned"
    "test_ptr_misaligned"
    # test/unit/test_heuristics_nvmatmul.py: queries the CUDA device
    "TestEndToEndRank"
  ];
in
buildPythonPackage (finalAttrs: {
  pname = "nvidia-cutlass-operators";
  # `__version__` of cutlass.operators, which is versioned independently of CUTLASS. A cudaPackages.cutlass update that
  # changes `__version__` breaks this package (pythonMetadataCheckHook) until passthru.updateScript is run, so run it in
  # the same change.
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  # cudaPackages.cutlass's source, so that Nixpkgs has one CUTLASS
  inherit (cudaPackages.cutlass) src;

  # Both are open upstream PRs, so they are vendored: each is the `git format-patch -1` of its PR's commit. Drop them
  # once a CUTLASS release includes them.
  patches = [
    # Import torch only where the blockscaled GEMM kernels need it, so `import cutlass.operators` works without the torch
    # extra
    # https://github.com/NVIDIA/cutlass/pull/3768 (open, a draft), commit 795b006d4afb17228d837a984a3921e3a8b225e6
    ./import-torch-only-where-needed.patch
    # pytest 9 moved running_on_ci from _pytest.assertion.util to _pytest.compat (test/utils, used by passthru.gpuCheck)
    # https://github.com/NVIDIA/cutlass/pull/3744 (open), commit 0da587a179827cec76a44a51e01fa37b5aa526d2
    ./test-sharding-pytest-9.patch
  ];

  # The patches apply to the CUTLASS tree; the package is in operators/.
  postPatch = "cd operators";

  build-system = [ setuptools ];

  dependencies = [
    apache-tvm-ffi
    networkx
    nvidia-cutlass-dsl
  ];

  # The jax extra is left out: jax is a large dependency for an alternative frontend.
  optional-dependencies = {
    heuristics = [ nvidia-matmul-heuristics ];
    torch = [
      torch
      torch-c-dlpack-ext
    ];
  };

  # The tests exercise both extras.
  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # `cutlass.operators` is reached through `nvidia-cutlass-dsl`'s `cutlass` package, which adds this
  # distribution's `cutlass/` directory to `cutlass.__path__` (`_APPROVED_CUTLASS_SIBLINGS`).
  pythonImportsCheck = [ "cutlass.operators" ];

  enabledTestPaths = [ "test/unit" ];
  disabledTestPaths = jaxTestPaths;
  disabledTests = gpuTests;

  passthru = {
    # Sets `version` to the `__version__` of cutlass.operators in the source, which cudaPackages.cutlass's updateScript
    # updates. (The default, nix-update, would set `version` to the CUTLASS release.) The file is an argument so that
    # maintainers/scripts/update.py can redirect it to its worktree.
    updateScript = [
      (lib.getExe (writeShellApplication {
        name = "nvidia-cutlass-operators-updater";
        text = ''
          init=${finalAttrs.src}/operators/cutlass/operators/__init__.py
          version="$(sed -nE 's/^__version__ = "(.+)"$/\1/p' "$init")"
          if [[ -z $version ]]; then
            echo "error: no __version__ in $init" >&2
            exit 1
          fi
          sed -i "s|^  version = \"${finalAttrs.version}\";$|  version = \"$version\";|" "$1"
          if ! grep -q "^  version = \"$version\";$" "$1"; then
            echo "error: could not set version = \"$version\" in $1" >&2
            exit 1
          fi
        '';
      }))
      (toString ./default.nix)
    ];
  }
  // lib.optionalAttrs torch.cudaSupport {
    gpuCheck = finalAttrs.finalPackage.overrideAttrs (prevAttrs: {
      requiredSystemFeatures = [ "cuda" ];

      # Load CUTLASS's own test_sharding plugin (test/utils at the root of the CUTLASS tree, outside sourceRoot), which
      # the operators conftest expects: it implements the `arch` marks, skipping kernels built for other SMs, such as the
      # sm100 block-scaled GEMMs on other GPUs. Without it, the arch marks are unknown and every test runs on every GPU.
      pytestFlags = [
        "-p"
        "test_sharding"
        # test/unit and test/integration both contain test_heuristics.py; upstream's CI uses importlib mode as well.
        "--import-mode=importlib"
      ];

      preCheck =
        (prevAttrs.preCheck or "")
        + (
          ''
            export PYTHONPATH="$PWD/../test/utils''${PYTHONPATH:+:$PYTHONPATH}"
          ''
          # The plugin selects tests for the GPU's compute capability; the device_info module it would otherwise query
          # isn't part of the release.
          + ''
            appendToVar pytestFlags "--target-cc=$(python -c 'import torch; print("%d%d" % torch.cuda.get_device_capability())')"
          ''
        );

      enabledTestPaths = [
        "test/unit"
        "test/integration"
      ];
      disabledTestPaths = jaxTestPaths ++ [
        # Executes the example notebooks with Jupyter
        "test/integration/test_notebooks.py"

        # Asserts host-side launch overhead stays under wall-clock thresholds
        "test/integration/test_overhead.py"
      ];
      disabledTests = [ ];
    });
  };

  meta = {
    description = "High-level discover/compile/execute API for CUTLASS Python kernels";
    homepage = "https://github.com/NVIDIA/cutlass/tree/main/operators";
    changelog = "https://github.com/NVIDIA/cutlass/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      GaetanLepage
      connorbaker
    ];
    teams = [ lib.teams.cuda ];
    platforms = lib.platforms.linux;
  };
})
