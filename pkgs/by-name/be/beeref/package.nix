{
  lib,
  python3Packages,
  fetchFromGitHub,
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

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    exif
    lxml
    rectangle-packer
    pyqt6
  ];

  pythonRelaxDeps = [
    "pyqt6"
    "rectangle-packer"
    "lxml"
  ];

  pythonRemoveDeps = [ "pyqt6-qt6" ];

  pythonImportsCheck = [ "beeref" ];

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
