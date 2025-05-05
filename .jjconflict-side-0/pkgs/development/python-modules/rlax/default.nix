{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  chex,
  distrax,
  dm-env,
  jax,
  jaxlib,
  numpy,
  tensorflow-probability,

  # tests
  dm-haiku,
  optax,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rlax";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "rlax";
    tag = "v${version}";
    hash = "sha256-v2Lbzya+E9d7tlUVlQQa4fuPp2q3E309Qvyt70mcdb0=";
  };

  # TODO: remove these patches at the next release (already on master)
  patches = [
    (fetchpatch {
      # Follow chex API change (https://github.com/google-deepmind/chex/pull/52)
      name = "replace-deprecated-chex-assertions";
      url = "https://github.com/google-deepmind/rlax/commit/30e7913a1102667137654d6e652a6c4b9e9ba1f4.patch";
      hash = "sha256-OPnuTKEtwZ28hzR1660v3DcktxTYjhR1xYvFbQvOhgs=";
    })
    (fetchpatch {
      name = "remove-deprecation-warning";
      url = "https://github.com/google-deepmind/rlax/commit/dea6eb479ffc32156aefe73015387a762c6b4562.patch";
      hash = "sha256-htDyDRJW0eQx7AmrS3Fl7Lbh2VAmoYiDgHSePsQUaWs=";
    })
    (fetchpatch {
      name = "fix-deprecation-warnings";
      url = "https://github.com/google-deepmind/rlax/commit/605e0ef8ad8f9a06e88d4aabbb7d50e086d0cf3a.patch";
      hash = "sha256-GZ/nGMXne6Lv6yDm/29NVTWxLBVSzaPYKAfQOLHY4UI=";
    })
    # https://github.com/google-deepmind/rlax/pull/135
    (fetchpatch {
      name = "fix-jax-0.6.0-compat";
      url = "https://github.com/google-deepmind/rlax/commit/461b4cf9b4239d6b1b83aad6e5946f68d8402b93.patch";
      hash = "sha256-uPMpm4IcoBWJwnyuIRjQEfo0F9HIW/lrwecxGW/Yw38=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    absl-py
    chex
    distrax
    dm-env
    jax
    jaxlib
    numpy
    tensorflow-probability
  ];

  nativeCheckInputs = [
    dm-haiku
    optax
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rlax" ];

  disabledTests = [
    # AssertionError: Array(2, dtype=int32) != 0
    "test_categorical_sample__with_device"
    "test_categorical_sample__with_jit"
    "test_categorical_sample__without_device"
    "test_categorical_sample__without_jit"

    # RuntimeError: Attempted to set 4 devices, but 1 CPUs already available:
    # ensure that `set_n_cpu_devices` is executed before any JAX operation.
    "test_cross_replica_scatter_add0"
    "test_cross_replica_scatter_add1"
    "test_cross_replica_scatter_add2"
    "test_cross_replica_scatter_add3"
    "test_cross_replica_scatter_add4"
    "test_learn_scale_shift"
    "test_normalize_unnormalize_is_identity"
    "test_outputs_preserved"
    "test_scale_bounded"
    "test_slow_update"
    "test_unnormalize_linear"
  ];

  meta = {
    description = "Library of reinforcement learning building blocks in JAX";
    homepage = "https://github.com/deepmind/rlax";
    changelog = "https://github.com/google-deepmind/rlax/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
