{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "beeref";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rbreu";
    repo = "beeref";
    tag = "v${version}";
    hash = "sha256-GtxiJKj3tlzI1kVXzJg0LNAUcodXSna17ZvAtsAEH4M=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    exif
    lxml
    pyqt6
    rectangle-packer
  ];

  pythonRelaxDeps = [
    "lxml"
    "pyqt6"
    "rectangle-packer"
  ];

  pythonRemoveDeps = [ "pyqt6-qt6" ];

  pythonImportsCheck = [ "beeref" ];

  # Tests fail with "Fatal Python error: Aborted" due to PyQt6 GUI initialization issues in sandbox
  # Only versionCheckHook and pythonImportsCheck are used for basic validation
  nativeCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/rbreu/beeref/blob/v${version}/CHANGELOG.rst";
    description = "Reference image viewer";
    homepage = "https://beeref.org";
    license = with lib.licenses; [
      cc0
      gpl3Only
    ];
    mainProgram = "beeref";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
