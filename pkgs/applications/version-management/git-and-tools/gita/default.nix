{ lib
, buildPythonApplication
, fetchPypi
, pyyaml
, setuptools
}:

buildPythonApplication rec {
  version = "0.10.9";
  pname = "gita";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fbzk9rj895s5fpbnsyy3gxwbf5spqycisx5cqwzxgm0n5qkz9dk";
  };

  propagatedBuildInputs = [
    pyyaml
    setuptools
  ];

  meta = with lib; {
    description = "A command-line tool to manage multiple git repos";
    homepage = "https://github.com/nosarthur/gita";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
