{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  nixosTests,
}:
let
  pname = "open-webui";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "open-webui";
    rev = "v${version}";
    hash = "sha256-kUdy8zSt8RvGlMKa0gxp0tnZbo7/igDeFV2zsel5LXA=";
  };

  frontend = buildNpmPackage {
    inherit pname version src;

    npmDepsHash = "sha256-sjQJn94GmSdOY1B2bmFTsxjLrc7LSBgDpWNrXIHunsg=";

    # Disabling `pyodide:fetch` as it downloads packages during `buildPhase`
    # Until this is solved, running python packages from the browser will not work.
    postPatch = ''
      substituteInPlace package.json \
        --replace-fail "npm run pyodide:fetch && vite build" "vite build" \
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
    openai
    opencv4
    openpyxl
    pandas
    passlib
    peewee
    peewee-migrate
    psycopg2
    pydub
    pyjwt
    pymongo
    pymysql
    pypandoc
    pypdf
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
    sqlalchemy
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
    description = "Full-stack of open-webui. open-webui is a user-friendly WebUI for LLMs (Formerly Ollama WebUI)";
    homepage = "https://github.com/open-webui/open-webui";
    changelog = "https://github.com/open-webui/open-webui/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shivaraj-bh ];
    mainProgram = "open-webui";
  };
}
