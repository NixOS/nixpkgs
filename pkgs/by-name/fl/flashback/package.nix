{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication {
  pname = "flashback";
  version = "0-unstable-2025-07-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cachebag";
    repo = "flashback";
    rev = "8d5a83a3087f5118af0d0964745b7d3af9928cf8";
    hash = "sha256-YFHM5ONdOPHFB00o0iFKYoaBLYXRdcVJrh7QAU/H0hk=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    click
    colorama
    google-api-python-client
    platformdirs
    python-dotenv
    tabulate
    textual
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      black
      flake8
      mypy
      pytest
    ];
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find old YouTube gems that the algorithm hides";
    longDescription = ''
      A YouTube search tool that helps you find older content by
      searching videos from specific years. Available as both a
      Terminal User Interface (TUI - Thanks to Textual) and Command
      Line Interface (CLI).
    '';
    homepage = "https://github.com/cachebag/flashback";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "flashback";
  };
}
