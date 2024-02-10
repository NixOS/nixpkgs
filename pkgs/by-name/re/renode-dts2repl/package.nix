{ lib
, python3
, fetchFromGitHub
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication {
  pname = "renode-dts2repl";
  version = "unstable-2024-02-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "dts2repl";
    rev = "84b14adc21fcd12b9772f69f9dcf702133fa6551";
    hash = "sha256-xFMkYjSZajQSflsTF1BtARUZWbnAvBRfN4gK3RAgeIU=";
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
