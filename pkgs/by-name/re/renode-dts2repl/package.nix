{
  lib,
  python3,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication {
  pname = "renode-dts2repl";
  version = "0-unstable-2026-09-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "dts2repl";
    rev = "75f2fce6c6d5829feaf14b11c1f39a0c95c4a62a";
    hash = "sha256-fHDB9ZcHPAj6AMZqEMY3H84GChzGkpnM3h8H7g3/lUY=";
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
