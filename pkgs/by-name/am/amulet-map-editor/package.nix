{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
  wrapGAppsHook3,
  gtk3,
}:
let
  version = "0.10.39";
in
python3.pkgs.buildPythonApplication {
  pname = "amulet-map-editor";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Amulet-Team";
    repo = "Amulet-Map-Editor";
    tag = version;
    hash = "sha256-6HwASoAi4amPTzAFnUTxn2PCzBRKi0wFXcTN1l10O8U=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  build-system = with python3.pkgs; [
    setuptools
    wheel
    cython
    versioneer
    numpy
  ];

  buildInputs = [ gtk3 ];

  dependencies = with python3.pkgs; [
    pillow
    wxpython
    numpy
    pyopengl
    packaging
    amulet-core
    amulet-nbt
    pymctranslate
    minecraft-resource-pack
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

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "amulet_map_editor" ];
  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minecraft world editor and converter that supports all versions since Java 1.12 and Bedrock 1.7";
    homepage = "https://github.com/Amulet-Team/Amulet-Map-Editor";
    changelog = "https://github.com/Amulet-Team/Amulet-Map-Editor/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
