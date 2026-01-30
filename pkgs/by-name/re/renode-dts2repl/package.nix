{
  lib,
  python3,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication {
  pname = "renode-dts2repl";
  version = "0-unstable-2026-01-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "dts2repl";
    rev = "778be81b48eeeeb7991a49a816b350e4a88e0be1";
    hash = "sha256-Bmfty8W02RVTFU5yhIhkcDmO2yE8ECV87kbAsNNRGcY=";
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
