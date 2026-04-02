{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "babeldoc";
  version = "0.5.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "funstory-ai";
    repo = "BabelDOC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ArLTv5AjpUdbsN8bQs03ATwg5ugXetld2FmHhicU8OE=";
  };

  patches = [
    (fetchpatch2 {
      name = "rename-python-levenshtein-to-levenshtein";
      url = "https://github.com/funstory-ai/BabelDOC/pull/542.patch?full_index=1";
      hash = "sha256-rjXhKVFivkJo54WdYiihqB3lrlu4YEwVZZkE4WBatWs=";
    })
  ];

  build-system = with python3Packages; [ hatchling ];

  dependencies =
    with python3Packages;
    [
      bitstring
      configargparse
      httpx
      huggingface-hub
      numpy
      onnx
      onnxruntime
      openai
      orjson
      charset-normalizer
      cryptography
      peewee
      psutil
      pymupdf
      rich
      toml
      tqdm
      xsdata
      msgpack
      pydantic
      tenacity
      scikit-image
      freetype-py
      tiktoken
      levenshtein
      opencv-python-headless
      rapidocr-onnxruntime
      pyzstd
      hyperscan
      rtree
      chardet
      scipy
      uharfbuzz
      scikit-learn
    ]
    ++ httpx.optional-dependencies.socks
    ++ (with xsdata.optional-dependencies; cli ++ lxml ++ soap);

  pythonImportsCheck = [ "babeldoc" ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    python3Packages.pytestCheckHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = "HOME";

  meta = {
    description = "PDF scientific paper translation and bilingual comparison library";
    homepage = "https://github.com/funstory-ai/BabelDOC";
    changelog = "https://github.com/funstory-ai/BabelDOC/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "babeldoc";
  };
})
