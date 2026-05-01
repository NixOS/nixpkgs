{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "isd";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kainctl";
    repo = "isd";
    tag = "v${version}";
    hash = "sha256-MEfjE0zRxSuBwBkjAz9cKhodS+I4CjjtuvbO+WwL9SM=";
  };

  build-system = with python3Packages; [
    hatchling
    setuptools
  ];

  dependencies = with python3Packages; [
    pfzy
    pydantic
    pydantic-settings
    pyyaml
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
    "isd_tui"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI to interactively work with systemd units";
    longDescription = ''
      isd (interactive systemd) is a TUI offering fuzzy search for systemd
      units, auto-refreshing previews, smart `sudo` handling, and a fully
      customizable interface for power-users and newcomers alike.
    '';
    homepage = "https://github.com/kainctl/isd";
    changelog = "https://github.com/kainctl/isd/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "isd";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = lib.platforms.linux;
  };
}
