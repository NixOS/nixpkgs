{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  nix-eval-jobs,
  nix-output-monitor,
  nix-update-script,
  bashInteractive,
}:

python3Packages.buildPythonApplication rec {
  pname = "nix-fast-build";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-fast-build";
    rev = "refs/tags/${version}";
    hash = "sha256-6X4BW+3C2nfkorMfe+tuoeYrdddxPtLqOJ1rZxuxPrc=";
  };

  build-system = [ python3Packages.setuptools ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath (
        [
          nix-eval-jobs
          nix-eval-jobs.nix
          bashInteractive
        ]
        ++ lib.optional (lib.meta.availableOn stdenv.buildPlatform nix-output-monitor.compiler) nix-output-monitor
      )
    }"
  ];

  # Don't run integration tests as they try to run nix
  # to build stuff, which we cannot do inside the sandbox.
  checkPhase = ''
    PYTHONPATH= $out/bin/nix-fast-build --help
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Combine the power of nix-eval-jobs with nix-output-monitor to speed-up your evaluation and building process";
    homepage = "https://github.com/Mic92/nix-fast-build";
    changelog = "https://github.com/Mic92/nix-fast-build/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      getchoo
      mic92
    ];
    mainProgram = "nix-fast-build";
  };
}
