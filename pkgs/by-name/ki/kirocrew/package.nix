{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  callPackage,
  versionCheckHook,
  nix-update-script,
  kiro-cli-unwrapped,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "kirocrew";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kirodotdev";
    repo = "KiroCrew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2YE7v2WFhskiCZMcQSSDWyzN0ANwuSQr0xz73biWYmc=";
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
      slack-sdk
      websockets
      cron-descriptor
      croniter
      numpy
      snowballstemmer
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
      uv # PPTX Maker provisions its presentation engine into a uv-managed venv
    ]
    ++ qrcode.optional-dependencies.pil
    # truststore provides Security.framework-backed TLS validation for the
    # bundled macOS Python runtime.
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ truststore ];

  # We do not need pysqlite3-binary, because the stdlib sqlite3 works because FTS5 is enabled unconditionally.
  pythonRemoveDeps = [ "pysqlite3-binary" ];

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

  # Fix skill copy permissions and sandbox defaults.
  postInstall = ''
    substituteInPlace $out/${python3.sitePackages}/kiro_crew/deploy/__init__.py \
      --replace-fail \
      'shutil.copytree(skill_dir, link)' \
      'shutil.copytree(skill_dir, link); [_p.chmod(_p.stat().st_mode | 0o200) for _p in [link, *link.rglob("*")]]'

    # Default agent.sandbox to "off" on Linux (bwrap nesting fails); macOS keeps "auto".
    substituteInPlace $out/${python3.sitePackages}/kiro_crew/config/loader.py \
      --replace-fail \
      'sandbox: str = field(${"\n"}        default="auto",' \
      'sandbox: str = field(${"\n"}        default="${
        if stdenv.hostPlatform.isLinux then "off" else "auto"
      }",' \
      --replace-fail \
      'sandbox=agent_data.get("sandbox", "auto"),' \
      'sandbox=agent_data.get("sandbox", "${if stdenv.hostPlatform.isLinux then "off" else "auto"}"),'
  '';

  pythonImportsCheck = [ "kiro_crew" ];

  # Use unwrapped kiro-cli on Linux to avoid bwrap nesting issues.
  # kirocrew discovers kiro-cli via PATH search, so propagatedBuildInputs
  # is sufficient (no need for explicit KIROCREW_KIRO_BIN environment variable).
  propagatedBuildInputs = lib.optional stdenv.hostPlatform.isLinux kiro-cli-unwrapped;

  doCheck = true;
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

    updateScript = nix-update-script { extraArgs = [ "--subpackage=frontend" ]; };
  };

  meta = {
    description = "Persistent, open source development workspace that remembers your context";
    longDescription = ''
      Kiro Crew is the persistent, open source development workspace that
      remembers your context, learns how you work, and coordinates across your
      unique tools and workflows, so you come back to progress instead of
      another workflow to restart.

      Kiro Crew reaches an LLM only through kiro-cli, which it drives over the
      Agent Client Protocol (ACP). Despite ACP being an open protocol, kiro-cli
      is currently the sole supported provider: `agent.provider` accepts no
      value other than "acp", and each session is spawned as
      `kiro-cli acp --agent <name>`. kiro-cli must therefore be installed
      separately, resolvable on PATH, and signed in via `kiro-cli login`. Kiro
      Crew only detects it; it never installs or authenticates on your behalf.
      Set KIROCREW_KIRO_BIN to point at a specific binary.
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
    # Matches the platforms supported by kiro-cli, the only ACP provider Kiro
    # Crew can use to reach an LLM.
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
