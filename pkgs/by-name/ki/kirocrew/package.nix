{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  callPackage,
  versionCheckHook,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "kirocrew";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "kirodotdev";
    repo = "KiroCrew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lNvpPz+oWsCfxBX3b/nGcGlYsSbYiGB5KrgRr2k5Jgs=";
  };

  pyproject = true;

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies =
    with python3.pkgs;
    [
      aiohttp
      yarl
      multidict
      slack-sdk
      websockets
      cron-descriptor
      croniter
      pathspec
      jsonschema
      markdown-it-py
      numpy
      snowballstemmer
      tzdata
      jinja2
      typing-extensions
      python-docx
      pdfplumber
      defusedxml
      qrcode
      openpyxl
      cryptography
      requests
      pyyaml
      opentelemetry-api
      opentelemetry-sdk
      uv # PPTX Maker provisions its engine into a uv-managed venv
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      truststore
    ]
    ++ qrcode.optional-dependencies.pil;

  # We do not need pysqlite3-binary, because the stdlib sqlite3 works because FTS5 is enabled unconditionally.
  # rjieba is not in nixpkgs. kirocrew imports it lazily and, when it is missing,
  # falls back to per-character segmentation for Chinese session search.
  pythonRemoveDeps = [
    "pysqlite3-binary"
    "rjieba"
  ];

  pythonRelaxDeps = [
    "websockets"
    "cron-descriptor"
    "croniter"
    "cryptography"
  ];

  # Stage the built dashboard into the tree where upstream expects it
  preBuild = ''
    rm -rf src/kiro_crew/static/dist
    mkdir -p src/kiro_crew/static
    cp -r ${finalAttrs.passthru.frontend} src/kiro_crew/static/dist
  '';

  postInstall =
    let
      sandboxDefault = if stdenv.hostPlatform.isLinux then "off" else "auto";
    in
    ''
      substituteInPlace $out/${python3.sitePackages}/kiro_crew/config/sections_agent.py \
        --replace-fail \
        'sandbox: str = field(${"\n"}        default="auto",' \
        'sandbox: str = field(${"\n"}        default="${sandboxDefault}",'
    '';

  pythonImportsCheck = [ "kiro_crew" ];

  nativeCheckInputs = [ versionCheckHook ];
  # kirocrew requires to be able to write to the home directory on startup
  preVersionCheck = ''
    export HOME=$(mktemp -d)
  '';
  versionCheckKeepEnvironment = [ "HOME" ];
  __structuredAttrs = true;

  passthru = {
    frontend = callPackage ./frontend.nix { kirocrew = finalAttrs.finalPackage; };
    optional-dependencies = with python3.pkgs; {
      voice = [
        boto3
        # amazon-transcribe not yet available in nixpkgs
      ];
    };

    updateScript = nix-update-script {
      extraArgs = [
        # kirocrew has some releases with "-insider" in the name; skip them.
        "--use-github-releases"
        "--subpackage=frontend"
      ];
    };
  };

  meta = {
    description = "Persistent, open source development workspace that remembers your context";
    longDescription = ''
      Kiro Crew is the persistent, open source development workspace that
      remembers your context, learns how you work, and coordinates across your
      unique tools and workflows, so you come back to progress instead of
      another workflow to restart.

      Kiro Crew reaches an LLM through an agent harness that it drives over
      the Agent Client Protocol (ACP). This package includes no harness;
      install one separately and sign in to it. The default harness is Kiro,
      which needs kiro-cli on PATH (set KIROCREW_KIRO_BIN to point at a
      specific binary). Claude Code, Codex, OpenCode, Pi, goose and DeepSeek
      can be chosen instead during first-run setup. Kiro Crew only detects
      harnesses; it never installs or authenticates them on your behalf.
    '';
    homepage = "https://kiro.dev/crew/";
    changelog = "https://github.com/kirodotdev/KiroCrew/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    # The source tree ships prebuilt native libraries for the vendored
    # llama-cpp-python runtime (src/kiro_crew/_vendor/llama_cpp_libs/*).
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      jamesward
      pmw
    ];
    mainProgram = "kirocrew";
  };
})
