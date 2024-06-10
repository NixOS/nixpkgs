{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  nixosTests,
}:
let
  pname = "open-webui";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "open-webui";
    rev = "v${version}";
    hash = "sha256-hUm4UUQUFoDRrAg+RqIo735iQs8304OUJlT91vILmXo=";
  };

  frontend = buildNpmPackage {
    inherit pname version src;

    npmDepsHash = "sha256-VdGneemYLMuMczjQB6I35Ry2kyIuAe2IaeDus/NvzK8=";

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
  # We don't have to worry, as node dependencies are managed by `frontend` drv.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '[tool.hatch.build.hooks.custom]' "" \
      --replace-fail ', build = "open_webui/frontend"' ""
  '';

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # using `opencv4`
    "opencv-python-headless"
    # using `psycopg2` instead
    "psycopg2-binary"
    # package request: https://github.com/NixOS/nixpkgs/issues/317065
    "rapidocr-onnxruntime"
  ];

  dependencies = with python3.pkgs; [
    aiohttp
    apscheduler
    argon2-cffi
    bcrypt
    beautifulsoup4
    black
    boto3
    chromadb
    docx2txt
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
    litellm
    markdown
    opencv4
    openpyxl
    pandas
    passlib
    peewee
    peewee-migrate
    psycopg2
    pyjwt
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
    requests
    sentence-transformers
    unstructured
    uvicorn
    validators
    xlrd
    youtube-transcript-api
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
