{
  lib,
  python3Packages,
  fetchFromGitHub,
  dmenu,
}:

python3Packages.buildPythonApplication rec {
  pname = "bitwarden-menu";
  version = "0.4.5-unstable-2025-08-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "bitwarden-menu";
    rev = "b7567137b8d24edc3b6914d7581df3ec06392ce0";
    hash = "sha256-gXdq8ublHgqXMr5Up51tLIFcTkntz/a7otMJXeznNDU=";
  };

  nativeBuildInputs = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  dependencies =
    with python3Packages;
    [
      pynput
      xdg-base-dirs
    ]
    ++ [
      dmenu
    ];

  doCheck = false;

  meta = {
    changelog = "https://github.com/firecat53/bitwarden-menu/releases/tag/v${version}";
    description = "Dmenu/Rofi frontend for managing Bitwarden vaults. Uses the Bitwarden CLI tool to interact with the Bitwarden database";
    mainProgram = "bwm";
    homepage = "https://github.com/firecat53/bitwarden-menu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aman9das ];
  };
}
