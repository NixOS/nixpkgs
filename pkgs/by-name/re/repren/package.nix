{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "repren";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlevy";
    repo = "repren";
    tag = version;
    hash = "sha256-UqJC19EvhQsLlecPwy6ixkvQTi/6w6RLI5DTeNzVIqE=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  meta = {
    description = "Simple but flexible command-line tool for rewriting file contents";
    homepage = "https://github.com/jlevy/repren";
    changelog = "https://github.com/jlevy/repren/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "repren";
  };
}
