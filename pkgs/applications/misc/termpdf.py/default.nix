{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  bibtool,
  pybtex,
  pymupdf,
  pynvim,
  pyperclip,
  roman,
  pdfrw,
  pagelabels,
  setuptools,
}:

buildPythonApplication {
  pname = "termpdf.py";
  version = "2022-03-28";

  src = fetchFromGitHub {
    owner = "dsanson";
    repo = "termpdf.py";
    rev = "e7bd0824cb7d340b8dba7d862e696dba9cb5e5e2";
    sha256 = "HLQZBaDoZFVBs4JfJcwhrLx8pxdEI56/iTpUjT5pBhk=";
  };

  propagatedBuildInputs = [
    bibtool
    pybtex
    pymupdf
    pyperclip
    roman
    pagelabels
    pdfrw
    pynvim
    setuptools
  ];

  # upstream doesn't contain tests
  doCheck = false;

  meta = with lib; {
    description = ''
      A graphical pdf (and epub, cbz, ...) reader that works
      inside the kitty terminal.
    '';
    mainProgram = "termpdf.py";
    homepage = "https://github.com/dsanson/termpdf.py";
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}
