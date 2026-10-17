{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-eval-jobs,
  nix-update-script,
  bashInteractive,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nix-fast-build";
  version = "2.0.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-fast-build";
    tag = finalAttrs.version;
    hash = "sha256-sc/NZIHkRhgyAzK8Xn6G++vGrl/Uf7QHh+J5fnZ/o4s=";
  };

  build-system = [ python3Packages.setuptools ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ": ${
      lib.makeBinPath [
        nix-eval-jobs
        nix-eval-jobs.nix
        bashInteractive
      ]
    }"
  ];

  nativeCheckInputs = with python3Packages; [
    pyte
    pytestCheckHook
  ];

  enabledTestPaths = [
    # The other test files run nix, which fails in the sandbox
    "tests/test_ci_renderer.py"
    "tests/test_log_format.py"
    "tests/test_term.py"
    "tests/test_tty_renderer.py"
  ];

  pythonImportsCheck = [ "nix_fast_build" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Speed-up your Nix evaluation and building process by running them in parallel";
    homepage = "https://github.com/Mic92/nix-fast-build";
    changelog = "https://github.com/Mic92/nix-fast-build/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      getchoo
      mic92
    ];
    mainProgram = "nix-fast-build";
  };
})
