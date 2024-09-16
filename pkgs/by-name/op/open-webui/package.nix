{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  nixosTests,
}:
let
  pname = "open-webui";
  version = "0.3.21";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "open-webui";
    rev = "refs/tags/v${version}";
    hash = "sha256-b+r+nEv+9IM56KkCi9tZqnEbyCX69mFhp0Be5/9lR9c=";
  };

  frontend = buildNpmPackage {
    inherit pname version src;

    npmDepsHash = "sha256-LH07LzYZpVzRAvkjoTgt7LJdXZZoDMt//ZAl30z7AHw=";

    # Disabling `pyodide:fetch` as it downloads packages during `buildPhase`
    # Until this is solved, running python packages from the browser will not work.
    postPatch = ''
      substituteInPlace package.json \
        --replace-fail "npm run pyodide:fetch && vite build" "vite build"
    '';

    env.CYPRESS_INSTALL_BINARY = "0"; # disallow cypress from downloading binaries in sandbox

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      cp -a build $out/share/open-webui

      runHook postInstall
    '';
  };
in
python3.pkgs.buildPythonApplication rec {
  inherit pname version src;
  pyproject = true;

  # Not force-including the frontend build directory as frontend is managed by the `frontend` derivation above.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', build = "open_webui/frontend"' ""
  '';

  env.HATCH_BUILD_NO_HOOKS = true;

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # using `opencv4`
    "opencv-python-headless"
    # using `psycopg2` instead
    "psycopg2-binary"
    "docker"
    "pytest"
    "pytest-docker"
  ];

  dependencies = with python3.pkgs; [
    aiohttp
    alembic
    anthropic
    apscheduler
    argon2-cffi
    authlib
    bcrypt
    beautifulsoup4
    black
    boto3
    chromadb
    docx2txt
    duckduckgo-search
    extract-msg
    fake-useragent
    fastapi
    faster-whisper
    flask
    flask-cors
    fpdf2
    google-generativeai
    langchain
    langchain-chroma
    langchain-community
    langfuse
    markdown
    nltk
    openai
    opencv4
    openpyxl
    pandas
    passlib
    peewee
    peewee-migrate
    psutil
    psycopg2
    pydub
    pyjwt
    pymongo
    pymysql
    pypandoc
    pypdf
    python-dotenv
    python-jose
    python-multipart
    python-pptx
    python-socketio
    pytube
    pyxlsb
    rank-bm25
    rapidocr-onnxruntime
    redis
    requests
    sentence-transformers
    tiktoken
    unstructured
    uvicorn
    validators
    xlrd
    youtube-transcript-api
  ];

  build-system = with python3.pkgs; [ hatchling ];

  pythonImportsCheck = [ "open_webui" ];

  makeWrapperArgs = [ "--set FRONTEND_BUILD_DIR ${frontend}/share/open-webui" ];

  passthru.tests = {
    inherit (nixosTests) open-webui;
  };

  meta = {
    description = "Comprehensive suite for LLMs with a user-friendly WebUI";
    homepage = "https://github.com/open-webui/open-webui";
    changelog = "https://github.com/open-webui/open-webui/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shivaraj-bh ];
    mainProgram = "open-webui";
  };
}
