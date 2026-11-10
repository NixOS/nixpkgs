{
  lib,
  python3Packages,
  fetchFromGitHub,
  tree,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "1.2.1";
in
python3Packages.buildPythonApplication {
  pname = "stown";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rseichter";
    repo = "stown";
    tag = version;
    hash = "sha256-B3gNFVeMRvN+bqBNCBLU1YqjGVz9wCbHUknWTTU8S6A=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    tree
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage file system object mapping via symlinks. Lightweight alternative to GNU Stow";
    homepage = "https://www.seichter.de/stown/";
    changelog = "https://github.com/rseichter/stown/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rseichter ];
    mainProgram = "stown";
  };
}
