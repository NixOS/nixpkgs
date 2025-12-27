{
  lib,
  python3,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication {
  pname = "renode-dts2repl";
  version = "0-unstable-2025-12-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "dts2repl";
    rev = "927f689d40c34fbe64f246abf9e6abf2d79f2fb5";
    hash = "sha256-cR/rMXGOLNyQDJSg77AI8+sco446sQNI/4IuuWHLDhE=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [ "dts2repl" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Tool for converting device tree sources into Renode's .repl files";
    homepage = "https://github.com/antmicro/dts2repl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "dts2repl";
  };
}
