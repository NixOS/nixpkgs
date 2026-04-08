{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "jellyfish";
  version = "0-unstable-2024-05-27";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "codereport";
    repo = "jellyfish";
    rev = "611fdf45c8950dfc06d22c2638aa73f9560203b4";
    hash = "sha256-IwqXR7oeQjFV4MGadqg1Y6a5tUYb3MdT2L6kDs5JvTo=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.sympy ];

  # there are no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Extension of the Jelly programming language created by Dennis Mitchell";
    homepage = "https://github.com/codereport/jellyfish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "jelly";
  };
}
