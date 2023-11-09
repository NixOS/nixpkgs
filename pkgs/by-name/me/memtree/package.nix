{ lib
, fetchFromGitHub
, nix-update-script
, python3Packages
}:

python3Packages.buildPythonApplication {
  pname = "memtree";
  version = "unstable-2023-11-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbraud";
    repo = "memtree";
    rev = "093caeef26ee944b5bf4408710f63494e442b5ff";
    hash = "sha256-j4LqWy7DxeV7pjwnCfpkHwug4p48kux6BM6oDJmvuUo=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    rich
  ];

  nativeCheckInputs = with python3Packages; [
    hypothesis
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    python -m pytest -v
    runHook postCheck
  '';

  pythonImportChecks = [ "memtree" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "Render cgroups tree annotated by memory usage";
    homepage = "https://github.com/nbraud/memtree";
    maintainers = with maintainers; [ nicoo ];
    platforms = platforms.linux;
  };
}
