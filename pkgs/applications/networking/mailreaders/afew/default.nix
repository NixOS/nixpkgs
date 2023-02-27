{ lib, python3Packages, notmuch }:

python3Packages.buildPythonApplication rec {
  pname = "afew";
  version = "3.0.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0wpfqbqjlfb9z0hafvdhkm7qw56cr9kfy6n8vb0q42dwlghpz1ff";
  };

  nativeBuildInputs = with python3Packages; [ sphinx setuptools-scm ];

  propagatedBuildInputs = with python3Packages; [
    python3Packages.setuptools python3Packages.notmuch chardet dkimpy
  ];

  nativeCheckInputs = with python3Packages; [
    freezegun notmuch
  ];

  makeWrapperArgs = [
    ''--prefix PATH ':' "${notmuch}/bin"''
  ];

  outputs = [ "out" "doc" ];

  postBuild =  ''
    ${python3Packages.python.interpreter} setup.py build_sphinx -b html,man
  '';

  postInstall = ''
    install -D -v -t $out/share/man/man1 build/sphinx/man/*
    mkdir -p $out/share/doc/afew
    cp -R build/sphinx/html/* $out/share/doc/afew
  '';


  meta = with lib; {
    homepage = "https://github.com/afewmail/afew";
    description = "An initial tagging script for notmuch mail";
    license = licenses.isc;
    maintainers = with maintainers; [ flokli ];
  };
}
