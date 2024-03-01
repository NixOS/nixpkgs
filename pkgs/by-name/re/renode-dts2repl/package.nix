{ lib
, python3
, fetchFromGitHub
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication {
  pname = "renode-dts2repl";
  version = "unstable-2024-02-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "dts2repl";
    rev = "de8d8b276ceaae79ea90ed67065e9616e06b2558";
    hash = "sha256-uiS/zzAf4lCg/yUAoci2JXrmwb3xsObuzSi1U08lSjo=";
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
