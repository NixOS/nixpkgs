{ stdenv, pythonPackages, notmuch }:

pythonPackages.buildPythonApplication rec {
  pname = "afew";
  version = "1.3.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0105glmlkpkjqbz350dxxasvlfx9dk0him9vwbl86andzi106ygz";
  };

  nativeBuildInputs = with pythonPackages; [ sphinx setuptools_scm ];

  propagatedBuildInputs = with pythonPackages; [
    pythonPackages.notmuch chardet dkimpy
  ] ++ stdenv.lib.optional (!pythonPackages.isPy3k) subprocess32;

  postBuild =  ''
    make -C docs man
  '';

  postInstall = ''
    mandir="$out/share/man/man1"
    mkdir -p "$mandir"
    cp docs/build/man/* "$mandir"
  '';

  makeWrapperArgs = [
    ''--prefix PATH ':' "${notmuch}/bin"''
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/afewmail/afew;
    description = "An initial tagging script for notmuch mail";
    license = licenses.isc;
    maintainers = with maintainers; [ garbas andir flokli ];
  };
}
