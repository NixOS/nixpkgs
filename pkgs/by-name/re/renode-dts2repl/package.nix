{ lib
, python3
, fetchFromGitHub
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication {
  pname = "renode-dts2repl";
  version = "0-unstable-2024-06-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "dts2repl";
    rev = "57a24220c5be33b2974c885bbe2f680c3799f3ce";
    hash = "sha256-0KmJujGcsElzsVU0tsXtXLzh3oL8wBwai8gtxUu02H0=";
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
