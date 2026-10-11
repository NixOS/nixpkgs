{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  python3Packages,
  testers,
}:
let
  pname = "nanobot";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "HKUDS";
    repo = "nanobot";
    tag = "v${version}";
    hash = "sha256-7rGw/e1C48h7UYr+XA6zA3W2KQxUSTYPuqqv4w6Gn4I=";
  };

  # The WebUI ships as Vite sources under `webui/`; the build writes its
  # output to `../nanobot/web/dist` (relative to `webui/`), which stays inside
  # the source tree, so we build it as a separate derivation and re-inject the
  # resulting assets into the Python build.
  frontend = buildNpmPackage {
    pname = "nanobot-webui";
    inherit version src;
    sourceRoot = "${src.name}/webui";

    # Upstream's committed package-lock.json is missing most `resolved` URLs,
    # which breaks the npm deps fetcher. Replace it with a regenerated copy
    # that has all tarball URLs filled in. The deps FOD and the main build
    # both see this patched lockfile.
    # Upstream's vite config writes to `../nanobot/web/dist`, outside the
    # writable build directory; redirect the build to a local `dist/` that we
    # copy into place in installPhase.
    postPatch = ''
      cp ${./webui-package-lock.json} package-lock.json
      substituteInPlace vite.config.ts \
        --replace-fail 'outDir: path.resolve(__dirname, "../nanobot/web/dist")' 'outDir: path.resolve(__dirname, "dist")'
    '';

    npmDepsHash = "sha256-XsJQAV+7IsQwFC0WXlF3JenRkq2Guc1Or4XmFyLNqu8=";
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
  __structuredAttrs = true;

  build-system = with python3Packages; [ hatchling ];

  # The upstream hatch build hook (`hatch_build.py`) builds the WebUI with
  # bun/npm at wheel-build time. We build the frontend separately above and
  # stage it before the Python build, so ask the hook to stay out of the way.
  env.NANOBOT_SKIP_WEBUI_BUILD = "1";

  preBuild = ''
    mkdir -p nanobot/web/dist
    cp -r ${frontend}/share/nanobot-webui/. nanobot/web/dist/
  '';

  # chardet and rich: nixpkgs ships chardet 6 and rich 15, newer than
  # upstream's <6.0.0 / <15.0.0 caps. boto3: nixpkgs ships 1.42.x, below
  # the bedrock extra's >=1.43.0 floor.
  pythonRelaxDeps = [
    "boto3"
    "chardet"
    "dulwich"
    "filelock"
    "json-repair"
    "pypdf"
    "rich"
  ];

  dependencies = with python3Packages; [
    anthropic
    chardet
    croniter
    ddgs
    defusedxml
    dulwich
    filelock
    httpx
    jinja2
    json-repair
    loguru
    lxml-html-clean
    mcp
    oauth-cli-kit
    openai
    openpyxl
    packaging
    prompt-toolkit
    pydantic
    pydantic-settings
    pypdf
    python-docx
    python-pptx
    pyyaml
    questionary
    readability-lxml
    rich
    tiktoken
    typer
    watchfiles
    websocket-client
    websockets
  ];

  # Upstream's `langfuse` extra is omitted: nixpkgs ships langfuse 4.x, outside
  # upstream's supported >=3,<4 range. `olostep` is not packaged in nixpkgs.
  # `documents` and `pdf` are compatibility shims whose deps are now core.
  # Chat-channel SDKs are declared per-channel in upstream plugin manifests,
  # installed on demand upstream, and are not bundled here.
  optional-dependencies = with python3Packages; {
    api = [ aiohttp ];
    azure = [ azure-identity ];
    bedrock = [ boto3 ];
  };

  pythonImportsCheck = [ "nanobot" ];

  passthru = {
    inherit frontend;
    # nanobot prints "🐈 nanobot v0.3.0"; match the "v<version>" word.
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
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
