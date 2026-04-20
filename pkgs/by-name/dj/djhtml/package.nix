{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "djhtml";
  version = "3.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rtts";
    repo = "djhtml";
    tag = finalAttrs.version;
    hash = "sha256-l3qxPwnEyJ0sZWquaol0bOX7QvImLc8IRTfyE2yqXCo=";
  };

  build-system = [ python3Packages.setuptools ];

  pythonImportsCheck = [ "djhtml" ];

  meta = {
    homepage = "https://github.com/rtts/djhtml";
    description = "Django/Jinja template indenter";
    changelog = "https://github.com/rtts/djhtml/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "djhtml";
  };
})
