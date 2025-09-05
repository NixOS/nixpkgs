{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "i3-swap-focus";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "olivierlemoal";
    repo = "i3-swap-focus";
    tag = version;
    hash = "sha256-pSbwOqpK6RBpFfoMH/gl/7rNshNEpOgR6vQ022upl2Q=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = [
    python3.pkgs.i3ipc
  ];

  meta = {
    description = "I3/sway script to toggle between last windows";
    homepage = "https://github.com/olivierlemoal/i3-swap-focus";
    changelog = "https://github.com/olivierlemoal/i3-swap-focus/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sandptel ];
    platforms = lib.platforms.linux;
    mainProgram = "i3-swap-focus";
  };
}
