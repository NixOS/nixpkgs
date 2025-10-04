{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "meshcore-cli";
  version = "0-unstable-2025-09-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdlamotte";
    repo = "meshcore-cli";
    rev = "0cb9b908bfbf0e49fe507b29ccfae9d371d28a10";
    hash = "sha256-OtwYeLLCFs850HyM+Cc7CbukgG5ajs4MTB6mumrI8F0=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    meshcore
    prompt-toolkit
    requests
  ];

  pythonImportsCheck = [
    "meshcore_cli"
  ];
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  meta = {
    description = "Command line interface to MeshCore node";
    homepage = "https://github.com/fdlamotte/meshcore-cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "meshcore-cli";
  };
}
