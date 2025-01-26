{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "isd";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "isd-project";
    repo = "isd";
    tag = "v${version}";
    hash = "sha256-YOQoI9PB096C/wNF9y5nrXkpJGbO6cXQ2U6I2Ece2PM=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = with python3.pkgs; [
    pfzy
    pydantic
    pydantic-settings
    textual
    types-pyyaml
    xdg-base-dirs
  ];

  pythonRelaxDeps = [
    "pydantic"
    "pydantic-settings"
    "types-pyyaml"
  ];

  pythonImportsCheck = [
    "isd"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI to interactively work with systemd units";
    longDescription = ''
      isd (interactive systemd) is a TUI offering fuzzy search for systemd
      units, auto-refreshing previews, smart `sudo` handling, and a fully
      customizable interface for power-users and newcomers alike.
    '';
    homepage = "https://github.com/isd-project/isd";
    changelog = "https://github.com/isd-project/isd/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      eljamm
    ];
    mainProgram = "isd";
  };
}
