{ buildPythonApplication
, lib
, fetchFromGitHub
, poetry
, termcolor
, questionary
, colorama
, decli
, tomlkit
, jinja2
, pyyaml
, argcomplete
, typing-extensions
}:

buildPythonApplication rec {
  pname = "commitizen";
  version = "2.20.3";

  src = fetchFromGitHub {
    owner = "commitizen-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rAm2GTRxZIHQmn/FM0IwwH/2h+oOvzGmeVr5xkvD/zA=";
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [
    termcolor
    questionary
    colorama
    decli
    tomlkit
    jinja2
    pyyaml
    argcomplete
    typing-extensions
  ];

  meta = with lib; {
    description = "Tool to create committing rules for projects, auto bump versions, and generate changelogs";
    homepage = "https://github.com/commitizen-tools/commitizen";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
