{ stdenv, pythonPackages, notmuch }:

pythonPackages.buildPythonApplication rec {
  pname = "afew";
  version = "1.2.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "121w7bd53xyibllxxbfykjj76n81kn1vgjqd22izyh67y8qyyk5r";
  };

  buildInputs = with pythonPackages; [ setuptools_scm ];

  propagatedBuildInputs = with pythonPackages; [
    pythonPackages.notmuch chardet
  ] ++ stdenv.lib.optional (!pythonPackages.isPy3k) subprocess32;

  SETUPTOOLS_SCM_PRETEND_VERSION = "${version}";

  postInstall = ''
    wrapProgram $out/bin/afew \
      --prefix LD_LIBRARY_PATH : ${notmuch}/lib
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/afewmail/afew;
    description = "An initial tagging script for notmuch mail";
    maintainers = with maintainers; [ garbas andir flokli ];
  };
}
