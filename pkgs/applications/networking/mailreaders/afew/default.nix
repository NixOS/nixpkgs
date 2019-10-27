{ stdenv, pythonPackages, notmuch }:

pythonPackages.buildPythonApplication rec {
  pname = "afew";
  version = "2.0.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0j60501nm242idf2ig0h7p6wrg58n5v2p6zfym56v9pbvnbmns0s";
  };

  nativeBuildInputs = with pythonPackages; [ sphinx setuptools_scm ];

  propagatedBuildInputs = with pythonPackages; [
    pythonPackages.setuptools pythonPackages.notmuch chardet dkimpy
  ] ++ stdenv.lib.optional (!pythonPackages.isPy3k) subprocess32;

  makeWrapperArgs = [
    ''--prefix PATH ':' "${notmuch}/bin"''
  ];

  outputs = [ "out" "doc" ];

  postBuild =  ''
    python setup.py build_sphinx -b html,man
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
