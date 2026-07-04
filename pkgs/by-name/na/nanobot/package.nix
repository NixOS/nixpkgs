{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  python3Packages,
  testers,
}:
let
  pname = "nanobot";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "HKUDS";
    repo = "nanobot";
    tag = "v${version}";
    hash = "sha256-CqXGrFoCq4lGBypLgcrKsz5v0LtgS1qxAzDS7aicgvk=";
  };

  frontend = buildNpmPackage {
    pname = "nanobot-webui";
    inherit version src;
    sourceRoot = "${src.name}/webui";

    postPatch = ''
      cp ${./webui-package-lock.json} package-lock.json
      substituteInPlace vite.config.ts \
        --replace-fail 'outDir: path.resolve(__dirname, "../nanobot/web/dist")' 'outDir: path.resolve(__dirname, "dist")'
    '';

    npmDepsHash = "sha256-FuB4cH7JzLCanxqQlviRZ+suQW2QJVyo86VdbwKSIAA=";
    npmDepsFetcherVersion = 2;

    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/nanobot-webui
      cp -r dist/. $out/share/nanobot-webui/

      runHook postInstall
    '';
  };
in
python3Packages.buildPythonApplication (finalAttrs: {
  inherit pname version src;
  pyproject = true;

  build-system = with python3Packages; [ hatchling ];

  env.NANOBOT_SKIP_WEBUI_BUILD = "1";

  preBuild = ''
    mkdir -p nanobot/web/dist
    cp -r ${frontend}/share/nanobot-webui/. nanobot/web/dist/
  '';

  pythonRelaxDeps = [
    "boto3"
    "anthropic"
    "chardet"
    "ddgs"
    "dulwich"
    "json-repair"
    "mcp"
    "pillow"
    "pypdf"
    "rapidfuzz"
    "rich"
    "sigstore"
    "websockets"
  ];

  dependencies = with python3Packages; [
    aiohttp
    anthropic
    chardet
    croniter
    cryptography
    ddgs
    defusedxml
    dulwich
    filelock
    httpx
    jinja2
    json-repair
    jsonschema
    loguru
    lxml-html-clean
    markdown-it-py
    mcp
    oauth-cli-kit
    openai
    openpyxl
    packaging
    pillow
    prompt-toolkit
    pydantic
    pydantic-settings
    pypdf
    python-docx
    python-pptx
    pyyaml
    qrcode
    questionary
    rapidfuzz
    readability-lxml
    referencing
    regex
    rich
    setproctitle
    sigstore
    socksio
    tiktoken
    typer
    tzdata
    tzlocal
    watchfiles
    websockets
    yarl
  ];

  optional-dependencies = with python3Packages; {
    api = [ ];
    azure = [ azure-identity ];
    bedrock = [ boto3 ];
  };

  pythonImportsCheck = [ "nanobot" ];

  passthru = {
    inherit frontend;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$(mktemp -d) nanobot --version";
      version = "v${version}";
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Lightweight, open-source personal AI agent for tools, chats, and workflows";
    homepage = "https://github.com/HKUDS/nanobot";
    changelog = "https://github.com/HKUDS/nanobot/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "nanobot";
    maintainers = with lib.maintainers; [ gdifolco ];
  };
})
