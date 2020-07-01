{ stdenv
, buildPythonApplication
, fetchFromGitHub
, fetchPypi
, bibtool
, pybtex
, pymupdf
, pynvim
, pyperclip
, roman
, pdfrw
, pagelabels
, setuptools
}:

buildPythonApplication {
  pname = "termpdf.py";
  version = "2019-10-03";

  src = fetchFromGitHub {
    owner = "dsanson";
    repo = "termpdf.py";
    rev = "4f3bdf4b5a00801631f2498f2c38c81e0a588ae2";
    sha256 = "05gbj2fqzqndq1mx6g9asa7i6z8a9jdjrvilfwx8lg23cs356m6m";
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

  meta = with stdenv.lib; {
    description = ''
      A graphical pdf (and epub, cbz, ...) reader that works
      inside the kitty terminal.
    '';
    homepage = "https://github.com/dsanson/termpdf.py";
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}
