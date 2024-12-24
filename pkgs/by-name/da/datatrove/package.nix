{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
let
  version = "0.2.0";
in
python3Packages.buildPythonPackage {
  pname = "datatrove";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "datatrove";
    rev = "refs/tags/v${version}";
    hash = "sha256-2NJja2yWeHOgo1pCuwHN6SgYnsimuZdK0jE8ucTH4r8=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools ];

  propagatedBuildInputs = with python3Packages; [
    dill
    fsspec
    huggingface-hub
    tokenizers
    humanize
    loguru
    multiprocess
    numpy
    rich
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];
  dependencies = with python3Packages; [
    boto3
    fasteners
    huggingface-hub
    moto
    nltk
    s3fs
    xxhash
  ];

  disabledTestPaths = [
    "tests/executor/test_local.py"
    "tests/pipeline/test_filters.py"
    "tests/pipeline/test_bloom_filter.py"
    "tests/pipeline/test_minhash.py"
    "tests/pipeline/test_sentence_deduplication.py"
    "tests/pipeline/test_tokenization.py"
    "tests/pipeline/test_exact_substrings.py"
  ];

  pythonImportsCheck = [ "datatrove" ];
  meta = {
    description = "Set of platform-agnostic customizable pipeline processing blocks for data processing";
    homepage = "https://github.com/huggingface/datatrove";
    changelog = "https://github.com/huggingface/datatrove/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    platforms = lib.platforms.all;
  };
}
