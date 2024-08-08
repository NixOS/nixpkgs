{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  nixosTests,
}:
let
  pname = "open-webui";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "open-webui";
    rev = "v${version}";
    hash = "sha256-jWO0mo26C+QTIX5j3ucDk/no+vQnAh7Q6JwB3lLM83k=";
  };

  frontend = buildNpmPackage {
    inherit pname version src;

    npmDepsHash = "sha256-QIgYHZusuq2QD8p8MGsNVhCbz6fR+qP9UuU/kbBkadc=";

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

  # The custom hook tries to run `npm install` in `buildPhase`.
  # We don't have to worry, as nodejs depedencies are managed by `frontend` drv.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '[tool.hatch.build.hooks.custom]' "" \
      --replace-fail ', build = "open_webui/frontend"' ""
  '';

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # using `psycopg2` instead
    "psycopg2-binary"
    # using `opencv4`
    "opencv-python-headless"
    # package request: https://github.com/NixOS/nixpkgs/issues/317065
    "rapidocr-onnxruntime"
    # package request: https://github.com/NixOS/nixpkgs/issues/317066
    "langfuse"
    # package request: https://github.com/NixOS/nixpkgs/issues/317068
    "langchain-chroma"
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    fastapi
    uvicorn
    python-multipart
    flask
    flask-cors
    python-socketio
    python-jose
    passlib
    requests
    aiohttp
    peewee
    peewee-migrate
    psycopg2
    pymysql
    bcrypt
    litellm
    boto3
    argon2-cffi
    apscheduler
    google-generativeai
    langchain
    langchain-community
    fake-useragent
    chromadb
    sentence-transformers
    pypdf
    docx2txt
    python-pptx
    unstructured
    markdown
    pypandoc
    pandas
    openpyxl
    pyxlsb
    xlrd
    validators
    opencv4
    fpdf2
    rank-bm25
    faster-whisper
    pyjwt
    black
    youtube-transcript-api
    pytube
  ];

  build-system = with python3.pkgs; [
    hatchling
    pythonRelaxDepsHook
  ];

  pythonImportsCheck = [ "open_webui" ];

  postInstall = ''
    wrapProgram $out/bin/open-webui \
      --set FRONTEND_BUILD_DIR "${frontend}/share/open-webui"
  '';

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
