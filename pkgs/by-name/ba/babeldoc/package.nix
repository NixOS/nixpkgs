{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "babeldoc";
  version = "0.5.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "funstory-ai";
    repo = "BabelDOC";
    tag = "v${version}";
    hash = "sha256-vBlrsJN/VkwmpBzZAqyZAxz5W2vgWx/jbUzvyzeKtUc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"python-levenshtein>=0.27.1"' '"Levenshtein>=0.27.1"'
  '';

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

  meta = {
    description = "PDF scientific paper translation and bilingual comparison library.";
    homepage = "https://github.com/funstory-ai/BabelDOC";
    # Limited platforms due to dependency `hyperscan`
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "babeldoc";
  };
}
