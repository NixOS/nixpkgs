{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "papis-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "alejandrogallo";
    repo = "papis";
    rev = "v${version}";
    sha256 = "03j4v40n93jg3bjh9rqvh4fvkms3hdbbdx9ncviq9s92n2ykwkin";
  };

  propagatedBuildInputs = with python3Packages; [
    papis-python-rofi
    requests
    argcomplete
    pyparsing
    configparser
    arxiv2bib
    pyyaml
    chardet
    beautifulsoup4
    vobject
    prompt_toolkit
    bibtexparser
    unidecode
    pyparser
    python_magic
    pylibgen
    urwid
  ];

  meta = {
    description = "a powerful and highly extensible command-line based document and bibliography manager";
    homepage    = https://github.com/alejandrogallo/papis;
    license     = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.matthiasbeyer ];
  };
}

