{
  lib,
  python313Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

let
  python3Packages = python313Packages;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "babeldoc";
  version = "0.6.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "funstory-ai";
    repo = "BabelDOC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eYCIXMYOJPGReDFkFdxgrhpkAG/pA14v3Si+5unfXz4=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    with python3Packages;
    [
      bitstring
      chardet
      charset-normalizer
      configargparse
      cryptography
      freetype-py
      httpx
      huggingface-hub
      hyperscan
      levenshtein
      msgpack
      numpy
      onnx
      onnxruntime
      openai
      opencv-python-headless
      orjson
      peewee
      psutil
      pydantic
      pymupdf
      pyzstd
      rapidocr-onnxruntime
      rich
      rtree
      scikit-image
      scikit-learn
      scipy
      tenacity
      tiktoken
      toml
      tqdm
      uharfbuzz
      xsdata
    ]
    ++ httpx.optional-dependencies.socks
    ++ (with xsdata.optional-dependencies; cli ++ lxml ++ soap);

  pythonImportsCheck = [ "babeldoc" ];

  # Upstream dropped its test suite in 0.6.0
  nativeCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "PDF scientific paper translation and bilingual comparison library";
    homepage = "https://github.com/funstory-ai/BabelDOC";
    changelog = "https://github.com/funstory-ai/BabelDOC/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "babeldoc";
  };
})
