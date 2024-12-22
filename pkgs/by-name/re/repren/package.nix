{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "repren";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlevy";
    repo = "repren";
    rev = "refs/tags/${version}";
    hash = "sha256-X1+WIfa75KLhulAF5blnwbyXjFtZTwkM0nAqAvxwW5A=";
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
