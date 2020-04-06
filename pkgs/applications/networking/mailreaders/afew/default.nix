{ stdenv, python3Packages, notmuch }:

python3Packages.buildPythonApplication rec {
  pname = "afew";
  version = "2.0.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0j60501nm242idf2ig0h7p6wrg58n5v2p6zfym56v9pbvnbmns0s";
  };

  nativeBuildInputs = with python3Packages; [ sphinx setuptools_scm ];

  propagatedBuildInputs = with python3Packages; [
    python3Packages.setuptools python3Packages.notmuch chardet dkimpy
  ] ++ stdenv.lib.optional (!python3Packages.isPy3k) subprocess32;

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


  meta = with stdenv.lib; {
    homepage = https://github.com/afewmail/afew;
    description = "An initial tagging script for notmuch mail";
    license = licenses.isc;
    maintainers = with maintainers; [ andir flokli ];
  };
}
