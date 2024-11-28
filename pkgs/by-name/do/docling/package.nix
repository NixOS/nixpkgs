{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "docling";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "docling";
    rev = "v${version}";
    hash = "sha256-XcrKufZWWE2b+INttHvehPvvQlHNWL/ghWysH/qmjw8=";
  };

  build-system = [
    python3.pkgs.poetry-core
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    certifi
    # deepsearch-glm # not yet packaged
    docling-core
    docling-ibm-models
    docling-parse
    easyocr
    filetype
    huggingface-hub
    lxml
    marko
    onnxruntime
    openpyxl
    pandas
    pyarrow
    pydantic
    pydantic-settings
    # pypdfium2 # not yet packaged
    python-docx
    python-pptx
    requests
    rtree
    scipy
    typer
  ];

  optional-dependencies = with python3.pkgs; {
    ocrmac = [
      # ocrmac # not yet packaged
    ];
    rapidocr = [
      onnxruntime
      rapidocr-onnxruntime
    ];
    tesserocr = [
      tesserocr
    ];
  };

  pythonImportsCheck = [
    "docling"
  ];

  meta = {
    description = "Get your documents ready for gen AI";
    homepage = "https://github.com/DS4SD/docling";
    changelog = "https://github.com/DS4SD/docling/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "docling";
  };
}
