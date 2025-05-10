{
  lib,
  fetchPypi,
  python3,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
let
  version = "0.10.42";
in
python3.pkgs.buildPythonApplication {
  pname = "amulet-map-editor";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "amulet_map_editor";
    hash = "sha256-3PSlIdsMWfmeGIBwktrR6pL+AbB5c/s3ZuBTMf05ST0=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
    cython
    versioneer
    numpy_1
  ];

  dependencies = with python3.pkgs; [
    pillow
    # need wxpython to use "numpy_1" instead of latest version
    (wxpython.overridePythonAttrs (_: {
      propagatedBuildInputs = [
        numpy_1
        pillow
        six
      ];
    }))
    pyopengl
    pymctranslate
    minecraft-resource-pack
    amulet-core
    amulet-nbt
    platformdirs
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      black
      pre-commit
    ];
    docs = [
      sphinx
      sphinx-autodoc-typehints
      sphinx-rtd-theme
    ];
  };

  # "requirements.py" is asking for older versions
  pythonRelaxDeps = [ "platformdirs" ];

  pythonImportsCheck = [ "amulet_map_editor" ];
  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minecraft world editor and converter that supports all versions since Java 1.12 and Bedrock 1.7";
    homepage = "https://github.com/Amulet-Team/Amulet-Map-Editor";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
