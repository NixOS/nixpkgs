{
  lib,
  fetchFromGitHub,
  smassh,
  python311,
  testers,
}:

let
  python3 = python311;
in
python3.pkgs.buildPythonApplication rec {
  pname = "smassh";
  version = "3.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kraanzu";
    repo = "smassh";
    rev = "v${version}";
    hash = "sha256-MeLub6zeviY7yyPP2FI9b37nUwHZbxW6onuFXSkmvqk";
  };

  nativeBuildInputs = with python3.pkgs; [ poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    click
    requests
    (textual.overridePythonAttrs (oldAttrs: {
      version = "0.52.1";
      src = fetchFromGitHub {
        owner = "Textualize";
        repo = "textual";
        rev = "refs/tags/v0.52.1";
        hash = "sha256-a5v8HS6ZswQOl/jIypFJTk+MuMsu89H2pAAlWMPkLjI=";
      };
      disabledTests = [
        "test_tracked_slugs"
        "test_textual_env_var"
        "test_register_language"
        "test_register_language_existing_language"
        "test_language_binary_missing"
      ];
    }))
  ];

  # No tests available
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = smassh;
    command = "HOME=$(mktemp -d) smassh --version";
  };

  meta = with lib; {
    description = "TUI based typing test application inspired by MonkeyType";
    homepage = "https://github.com/kraanzu/smassh";
    changelog = "https://github.com/kraanzu/smassh/blob/main/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aimpizza ];
    mainProgram = "smassh";
  };
}
