{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "memtree";
  version = "0-unstable-2025-06-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nicoonoclaste";
    repo = "memtree";
    rev = "ad1a7d1e4fa5f195c2aa1012101d01ab580a05e8";
    hash = "sha256-UmleB7wr1bh9t7vwt3o8Uwp3LUzAzB5jlPi3OvgECAg=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
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
