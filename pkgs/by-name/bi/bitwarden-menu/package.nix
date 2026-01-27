{
  lib,
  python3Packages,
  fetchFromGitHub,
  dmenu,
  menu ? dmenu,
}:

python3Packages.buildPythonApplication rec {
  pname = "bitwarden-menu";
  version = "0.4.5-unstable-2025-08-17";
  pyproject = true;

  # Workaround: strip the suffix so setuptools_scm sees a valid PEP 440 version
  env.SETUPTOOLS_SCM_PRETEND_VERSION = builtins.elemAt (builtins.split "-" version) 0;

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "bitwarden-menu";
    rev = "b7567137b8d24edc3b6914d7581df3ec06392ce0";
    hash = "sha256-gXdq8ublHgqXMr5Up51tLIFcTkntz/a7otMJXeznNDU=";
  };

  build-system = [
    python3Packages.hatch-vcs
    python3Packages.hatchling
  ];

  dependencies = [
    python3Packages.pynput
    python3Packages.xdg-base-dirs
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ dmenu ]}"
  ];

  doCheck = false;

  meta = {
    changelog = "https://github.com/firecat53/bitwarden-menu/releases/tag/v${version}";
    description = "Dmenu/Rofi frontend for managing Bitwarden vaults. Uses the Bitwarden CLI tool to interact with the Bitwarden database";
    mainProgram = "bwm";
    homepage = "https://github.com/firecat53/bitwarden-menu";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.aman9das ];
  };
}
