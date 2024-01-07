{ lib
, fetchFromGitHub
, nix-update-script
, python3Packages
}:

python3Packages.buildPythonApplication {
  pname = "memtree";
  version = "unstable-2023-11-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbraud";
    repo = "memtree";
    rev = "edc09d91dcd72f175d6adc1d08b261dd95cc4fbf";
    hash = "sha256-YLZm0wjkjaTw/lHY5k4cqPXCgINe+49SGPLZq+eRdI4=";
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
