{
  fetchFromGitHub,
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pyproject = true;
  pname = "inventree";
  version = "1.15.1";
  src = fetchFromGitHub {
    owner = "inventree";
    repo = "plugin-creator";
    tag = "${version}";
    hash = "sha256-6sQL2ZizlMVrjhQExp8Piry1C0SxFM8hOn3l9ZlUIDA=";
  };

  dependencies = with python3Packages; [
    appdirs
    cookiecutter
    license
    questionary
    twine
  ];

  build-system = [ python3Packages.setuptools ];

  meta = {
    description = "Command line tool for scaffolding a new InvenTree plugin";
    homepage = "https://github.com/inventree/plugin-creator";
    changelog = "https://github.com/inventree/plugin-creator/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "create-inventree-plugin";
    maintainers = with lib.maintainers; [ gigahawk ];
  };
}
