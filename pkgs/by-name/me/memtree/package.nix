{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "memtree";
  version = "0-unstable-2025-06-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbraud";
    repo = "memtree";
    rev = "279f1fa0a811de86c278ce74830bd8aa1b00db58";
    hash = "sha256-gUULox3QSx68x8lb1ytanY36cw/I9L4HdpR8OPOsxuc=";
  };

  pythonRelaxDeps = [ "rich" ];

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
