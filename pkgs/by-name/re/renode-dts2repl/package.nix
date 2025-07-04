{
  lib,
  python3,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication {
  pname = "renode-dts2repl";
  version = "0-unstable-2025-06-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "dts2repl";
    rev = "65232f0be8d171650e050690ade02c50755241c4";
    hash = "sha256-v/RzEXRie3O37DVVY7bX09rnXMLH7L99o8sWPOPnDOw=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [ "dts2repl" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Tool for converting device tree sources into Renode's .repl files";
    homepage = "https://github.com/antmicro/dts2repl";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
    mainProgram = "dts2repl";
  };
}
