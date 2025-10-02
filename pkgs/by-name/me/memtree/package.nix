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
    hash = "sha256-stIRBXhaLqYsN2WMQnu46z39ssantzM8M6T3kCOoZKc=";

    # Remove irrelevant content, avoid src hash change on flake.lock updates etc.
    postFetch = "rm -r $out/.* $out/flake.* $out/bors.toml";
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

  pytestFlags = [ "-v" ];
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
