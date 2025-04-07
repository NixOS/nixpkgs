{
  lib,
  python3Packages,
  fetchFromGitHub,
  tree,
  versionCheckHook,
}:
let
  version = "1.2.0";
in
python3Packages.buildPythonApplication {
  pname = "stown";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rseichter";
    repo = "stown";
    tag = version;
    hash = "sha256-iHeqmlo7be28ISJfPZ7GZC2gj2VVgt20ORnfYVToo0A=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    tree
    versionCheckHook
  ];

  meta = {
    description = "Manage file system object mapping via symlinks. Lightweight alternative to GNU Stow";
    homepage = "https://www.seichter.de/stown/";
    changelog = "https://github.com/rseichter/stown/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rseichter ];
    mainProgram = "stown";
  };
}
