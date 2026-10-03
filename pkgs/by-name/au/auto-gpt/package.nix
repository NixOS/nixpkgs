{ lib
, python3
, fetchFromGitHub
}:
let
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "Significant-Gravitas";
    repo = "Auto-GPT";
    rev = "autogpt-v${version}";
    hash = "sha256-EkE4+mP341FOgLeD4BgkoSd5WTW5+wezYl+WudOGMLU=";
    fetchSubmodules = true;
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "auto-gpt";
  inherit version src;
  format = "pyproject";

  disabled = python3.pythonOlder "3.10";

  sourceRoot = "${src.name}/autogpts/autogpt";

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    boto3
    charset-normalizer
    click
    colorama
    distro
    docker
    duckduckgo-search
    # en-core-web-sm
    fastapi
    ftfy
    google-api-python-client
    gtts
    hypercorn
    inflection
    jsonschema
    numpy
    openai
    orjson
    pillow
    pinecone-client
    playsound
    prompt-toolkit
    pydantic
    pylatexenc
    pypdf
    python-docx
    python-dotenv
    pyyaml
    readability-lxml
    redis
    requests
    selenium
    spacy
    tiktoken
    # webdriver-manager

    # openapi-python-client

    # agbenchmark
    google-cloud-logging
    google-cloud-storage
    psycopg2
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    asynctest
    coverage
    pytest-asyncio
    pytest-benchmark
    pytest-cov
    pytest-integration
    pytest-mock
    pytest-recording
    pytest-xdist
    vcrpy
  ];

  # asynctest is unmaintained and incompatible with 3.11
  doCheck = false;

  pythonImportsCheck = [ "autogpt" ];

  meta = with lib; {
    description = "An experimental open-source attempt to make GPT-4 fully autonomous";
    homepage = "https://github.com/Significant-Gravitas/Auto-GPT";
    changelog = "https://github.com/Significant-Gravitas/Auto-GPT/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
