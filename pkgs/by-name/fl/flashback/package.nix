{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "flashback";
  version = "2.30.0";
  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cachebag";
    repo = "flashback";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hZpsLI/diCnw/ORjDLt3VzyTJcl519TH2bOoHL8bODY=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    click
    colorama
    google-api-python-client
    platformdirs
    python-dotenv
    tabulate
    textual
  ];

  pythonImportsCheck = [ "flashback" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find old YouTube gems that the algorithm hides";
    longDescription = ''
      A YouTube search tool that helps you find older content by
      searching videos from specific years.  Available as both a
      Terminal User Interface (TUI - Thanks to Textual) and Command
      Line Interface (CLI).
    '';
    homepage = "https://github.com/cachebag/flashback";
    changelog = "https://github.com/cachebag/flashback/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ytflashback";
  };
})
