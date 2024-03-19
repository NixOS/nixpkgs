{ lib
, python3
, fetchFromGitHub
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication {
  pname = "renode-dts2repl";
  version = "unstable-2024-03-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "dts2repl";
    rev = "eff98d616e3541e54ca783c84f598c9e348a76a8";
    hash = "sha256-qNHj5WOSca04ceGeRNa60M6cH9/rRHLEF1YX75yYDO8=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [ "dts2repl" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A tool for converting device tree sources into Renode's .repl files";
    homepage = "https://github.com/antmicro/dts2repl";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
    mainProgram = "dts2repl";
  };
}
