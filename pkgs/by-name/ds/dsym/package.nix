{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dsym";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nerdbude";
    repo = "dsym";
    rev = version;
    hash = "sha256-rJHW0/odcav/3H7REBhMqKlORpsFdWJdO5pzowFhbDY=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [
    "dsym"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage your dotfiles using git";
    homepage = "https://github.com/nerdbude/dsym";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ _0x17 ];
    mainProgram = "dsym";
  };
}
