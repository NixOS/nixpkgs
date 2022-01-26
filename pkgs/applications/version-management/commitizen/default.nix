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
, packaging
}:

buildPythonApplication rec {
  pname = "commitizen";
  version = "2.20.4";

  src = fetchFromGitHub {
    owner = "commitizen-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2DhWiUAkAkyNxYB1CGzUB2nGZeCWvFqSztrxasUPSXw=";
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
    packaging
  ];

  meta = with lib; {
    description = "Tool to create committing rules for projects, auto bump versions, and generate changelogs";
    homepage = "https://github.com/commitizen-tools/commitizen";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
