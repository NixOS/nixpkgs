{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  torch,
  triton,

  # optional-dependencies
  accelerate,
  datasets,
  fire,
  huggingface-hub,
  pandas,
  pytestCheckHook,
  pythonAtLeast,
  tqdm,
  transformers,
}:

buildPythonPackage {
  pname = "cut-cross-entropy";
  version = "25.3.1";
  pyproject = true;

  # The `ml-cross-entropy` Pypi comes from a third-party.
  # Apple recommends installing from the repo's main branch directly
  src = fetchFromGitHub {
    owner = "apple";
    repo = "ml-cross-entropy";
    rev = "24fbe4b5dab9a6c250a014573613c1890190536c"; # no tags
    hash = "sha256-BVPon+T7chkpozX/IZU3KZMw1zRzlYVvF/22JWKjT2Y=";
  };

  # Python 3.13 support requires PyTorch 2.6, which is not merged into master yet
  # https://github.com/NixOS/nixpkgs/pull/377785
  disabled = pythonAtLeast "3.13";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    torch
    triton
  ];

  optional-dependencies = {
    transformers = [ transformers ];
    all = [
      accelerate
      datasets
      fire
      huggingface-hub
      pandas
      tqdm
      transformers
    ];
    # `deepspeed` is not yet packaged in nixpkgs
    # ++ lib.optionals (!stdenv.isDarwin) [
    #   deepspeed
    # ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "cut_cross_entropy"
  ];

  meta = {
    description = "Memory-efficient cross-entropy loss implementation using Cut Cross-Entropy (CCE)";
    homepage = "https://github.com/apple/ml-cross-entropy";
    license = lib.licenses.aml;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
