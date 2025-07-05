{
  pkgs,
  lib,
  fetchFromGitHub,
  python3,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
let
  version = "0.10.44";
  python3 = pkgs.python312;
in
python3.pkgs.buildPythonApplication {
  pname = "amulet-map-editor";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Amulet-Team";
    repo = "Amulet-Map-Editor";
    tag = version;
    hash = "sha256-+6u7Ou+zyDkuyHZXH5J/pX3ygKJx2AsXJK+KmaIMSh0=";
  };

  nativeBuildInputs = with pkgs; [
    (python3.pkgs.setuptools)
    (python3.pkgs.wheel)
    (python3.pkgs.cython)
    (python3.pkgs.versioneer)
    (python3.pkgs.numpy_1)
    wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    gsettings-desktop-schemas
    adwaita-icon-theme
    xdg-desktop-portal-gtk
  ];

  dependencies = with python3.pkgs; [
    pillow
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
    changelog = "https://github.com/Amulet-Team/Amulet-Map-Editor/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [
      tibso
      erkin
    ];
  };
}
