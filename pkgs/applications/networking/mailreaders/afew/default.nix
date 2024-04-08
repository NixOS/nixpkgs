{ lib, python3Packages, fetchPypi, pkgs, testers, afew }:

python3Packages.buildPythonApplication rec {
  pname = "afew";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wpfqbqjlfb9z0hafvdhkm7qw56cr9kfy6n8vb0q42dwlghpz1ff";
  };

  nativeBuildInputs = with python3Packages; [
    sphinxHook
    setuptools
    setuptools-scm
  ];

  sphinxBuilders = [
    "html"
    "man"
  ];

  propagatedBuildInputs = with python3Packages; [
    chardet
    dkimpy
    notmuch
    setuptools
  ];

  nativeCheckInputs = [
    pkgs.notmuch
  ] ++ (with python3Packages; [
    freezegun
    pytestCheckHook
  ]);

  makeWrapperArgs = [
    ''--prefix PATH ':' "${pkgs.notmuch}/bin"''
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = afew;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/afewmail/afew";
    description = "An initial tagging script for notmuch mail";
    mainProgram = "afew";
    license = licenses.isc;
    maintainers = with maintainers; [ flokli ];
  };
}
