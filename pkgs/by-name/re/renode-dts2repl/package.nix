{
  lib,
  python3,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication {
  pname = "renode-dts2repl";
  version = "0-unstable-2026-06-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "dts2repl";
    rev = "ecd06775c379e4b45b3f4d9176782695ee479014";
    hash = "sha256-hv+ulJEZdB38E9ljIeRa3LupouGGiBffjNWBidhNcoQ=";
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
