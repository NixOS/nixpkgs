{
  lib,
  fetchFromGitHub,
  python3Packages,
  rustPlatform,
  cargo,
  rustc,

  # tests
  gitMinimal,
  ripgrep,
  writableTmpDirAsHomeHook,

  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "seagoat";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kantord";
    repo = "SeaGOAT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lsEu58GWdVdunip0n3fdrqjEABnpZDQ4iWtaIBb4M/U=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-HYlUKQSUPcQknd+ie8OAyOfFHXifYS/TcuxLlhWYhLE=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  pythonRelaxDeps = [
    "certifi"
    "chardet"
    "openai"
    "platformdirs"
    "stop-words"
  ];

  dependencies = with python3Packages; [
    certifi
    chardet
    chromadb
    click
    deepmerge
    flask
    jsonschema
    mcp
    ollama
    openai
    orjson
    packaging
    platformdirs
    psutil
    pygments
    pyyaml
    requests
    stop-words
    tqdm
    waitress
    yaspin
  ];

  pythonImportsCheck = [ "seagoat" ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
      freezegun
      gitpython
      pytest-asyncio
      pytest-mock
      pytest-timeout
      syrupy
    ]
    ++ [
      gitMinimal
      ripgrep
      versionCheckHook
      writableTmpDirAsHomeHook
    ];

  pytestFlags = [
    # The snapshot of the (disabled) test_snapshot_results_with_real_repo is unused
    "--snapshot-warn-unused"
  ];

  disabledTests = import ./failing_tests.nix;

  # require network access
  disabledTestPaths = [
    "tests/test_chroma.py"
  ];

  preCheck =
    # Prevent the source tree (without the compiled _native module) from shadowing the installed package
    ''
      rm -rf seagoat
    ''
    + ''
      git init
    '';

  __darwinAllowLocalNetworking = true;

  postInstall = ''
    wrapProgram $out/bin/seagoat-server \
      --prefix PATH : "${ripgrep}/bin"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Local-first semantic code search engine";
    homepage = "https://kantord.github.io/SeaGOAT/";
    changelog = "https://github.com/kantord/SeaGOAT/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lavafroth ];
    mainProgram = "seagoat";
  };
})
