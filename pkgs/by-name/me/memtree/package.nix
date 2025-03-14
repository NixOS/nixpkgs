{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "memtree";
  version = "0-unstable-2024-01-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbraud";
    repo = "memtree";
    rev = "97615952eabdc5e8e1a4bd590dd1f4971f3c5a24";
    hash = "sha256-Ifp8hwkuyBw57fGer3GbDiJaRjL4TD3hzj+ecGXWqI0=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    rich
  ];

  nativeCheckInputs = with python3Packages; [
    hypothesis
    pytestCheckHook
  ];

  pytestFlagsArray = [ "-v" ];
  pythonImportsCheck = [ "memtree" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "Render cgroups tree annotated by memory usage";
    homepage = "https://github.com/nbraud/memtree";
    maintainers = with maintainers; [ nicoo ];
    mainProgram = "memtree";
    platforms = platforms.linux;
  };
}
