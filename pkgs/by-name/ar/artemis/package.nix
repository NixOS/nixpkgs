{
  lib,
  callPackage,
  fetchFromGitHub,
  python3Packages,
  android-tools,
  ffmpeg,
  scrcpy,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "artemis";
  version = "0-unstable-2026-09-11";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "artemis";
    rev = "371aa6df56880643da57b30da936e9812fb0ec66";
    hash = "sha256-+zigHvrvAq8kjCMCxg+q87n0/SLC4jDP6BevuRbIx/g=";
  };

  postPatch = ''
    # Screenshots are saved in the installation directory, which for us
    # is immutable as it's in the nix store, so save them under Artemis's
    # application directory instead.
    substituteInPlace mcp_server/tools/device_state.py \
      --replace-fail 'from mcp_server.utils import env_utils' \
        'from artemis.config.paths import get_app_dir' \
      --replace-fail $'        project_root = env_utils.get_project_root()\n' "" \
      --replace-fail \
        '            screenshot_path = os.path.join(project_root, screenshot_filename)' \
        $'            screenshot_dir = get_app_dir() / "screenshots"\n            screenshot_dir.mkdir(parents=True, exist_ok=True)\n            screenshot_path = screenshot_dir / screenshot_filename' \
      --replace-fail $'import os\n' ""

    substituteInPlace mcp_server/utils/env_utils.py \
      --replace-fail 'return sys.executable' 'return "'"$out"'/libexec/artemis-python"'

    # This test omits HOME and replaces PYTHONPATH with the source directory
    substituteInPlace tests/unit/mcp/test_mcp_stdio_lifecycle.py \
      --replace-fail '"PYTHONPATH": project_root,' \
        '"PYTHONPATH": os.pathsep.join([project_root, os.environ.get("PYTHONPATH", "")]), "HOME": os.environ["HOME"],'

    # Importing the full SDK stack can exceed six seconds on sandbox builders
    substituteInPlace tests/unit/mcp/test_mcp_stdio_lifecycle.py \
      --replace-fail '_readline_with_timeout(p.stdout, 6.0)' '_readline_with_timeout(p.stdout, 30.0)' \
      --replace-fail 'within 6 seconds' 'within 30 seconds'
  '';

  build-system = with python3Packages; [
    cython
    setuptools
  ];

  preBuild = ''
    # Importing Artemis during the build creates directories under HOME
    # Give it a writable home inside the temporary build directory
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    mkdir -p apps/showcase_ui/dist/frontend
    cp -r ${finalAttrs.passthru.frontend} apps/showcase_ui/dist/frontend/browser
  '';

  postInstall = ''
    # The python installer does not include the
    # Android accessibility helper APK or its manifest
    install -Dm644 packages/artemis-accessibility-helper/ArtemisAccessibilityHelper.apk \
      "$out/${python3Packages.python.sitePackages}/packages/artemis-accessibility-helper/ArtemisAccessibilityHelper.apk"
    install -Dm644 packages/artemis-accessibility-helper/helper_manifest.json \
      "$out/${python3Packages.python.sitePackages}/packages/artemis-accessibility-helper/helper_manifest.json"

    # Include the Markdown files used by `artemis mcp --install` when setting up
    # an IDE; the python installer does not install them
    cp mcp_server/*.md "$out/${python3Packages.python.sitePackages}/mcp_server/"

    makeWrapper ${python3Packages.python.interpreter} "$out/libexec/artemis-python" \
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:${python3Packages.makePythonPath finalAttrs.passthru.dependencies}" \
      --prefix PATH : ${
        lib.makeBinPath [
          android-tools
          ffmpeg
          scrcpy
        ]
      }
  '';

  # Artemis requests versions of these libs that are newer than the packaged ones
  pythonRelaxDeps = [
    "google-genai"
    "langchain-anthropic"
  ];

  dependencies =
    with python3Packages;
    [
      adbutils
      artemis-client
      colorama
      fastapi
      google-genai
      httpx
      imageio-ffmpeg
      inquirer
      ipykernel
      jinja2
      jupyter-client
      langchain
      langchain-anthropic
      langchain-community
      langchain-core
      langchain-google-genai
      langchain-google-vertexai
      langchain-mcp-adapters
      langchain-openai
      langgraph
      matplotlib
      mcp
      numpy
      opencv-python
      pillow
      posthog
      psutil
      pydantic
      pydantic-settings
      python-dotenv
      requests
      retry
      rich
      scipy
      sseclient-py
      typer
      typing-extensions
      uiautomator2
      uuid-utils
      uvicorn
      websockets
    ]
    ++ python3Packages.uvicorn.optional-dependencies.standard;

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      android-tools
      ffmpeg
      scrcpy
    ])
  ];

  # Export PYTHONPATH from the CLI wrapper so workers inherit Artemis and its deps
  preFixup = ''
    makeWrapperArgs+=(--prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:${python3Packages.makePythonPath finalAttrs.passthru.dependencies}")
  '';

  nativeCheckInputs = with python3Packages; [
    android-tools
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # windows only
    "test_ensure_emulator_uses_windows_creation_flags"
  ];

  preCheck = ''
    # supply dummy key for mock API tests
    export GOOGLE_API_KEY=testing
  '';

  pythonImportsCheck = [
    "artemis"
    "artemis.interfaces.cli.main"
    "mcp_server"
  ];

  passthru = {
    frontend = callPackage ./frontend.nix {
      inherit (finalAttrs) src version;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
        "--subpackage=frontend"
      ];
    };
  };

  meta = {
    description = "Autonomous AI Assistant for Mobile Automation";
    homepage = "https://github.com/google/artemis";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # The prebuilt accessibility helper apk
    ];
    maintainers = with lib.maintainers; [ aaravrav ];
    mainProgram = "artemis";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    identifiers.purlParts = {
      type = "github";
      spec = "google/artemis@${finalAttrs.src.rev}";
    };
  };
})
