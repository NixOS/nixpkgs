{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "seashells";
  version = "0.1.2";
  format = "setuptools";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-RBs28FC7f82DrxRcmvTP9nljVpm7tjrGuvr05l32hDM=";
  };

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "seashells" ];

  meta = with lib; {
    homepage = "https://seashells.io/";
    description = "Pipe command-line programs to seashells.io";
    longDescription = ''
      Official cient for seashells.io, which allows you to view
      command-line output on the web, in real-time.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ deejayem ];
  };
}
