{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "py2bit";
  version = "0.3.0";
  format = "setuptools";

  checkInput = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vw2nvw1yrl7ikkqsqs1pg239yr5nspvd969r1x9arms1k25a1a5";
  };

  meta = with lib; {
    homepage = "https://github.com/deeptools/py2bit";
    description = "File access to 2bit files";
    longDescription = ''
      A python extension, written in C, for quick access to 2bit files. The extension uses lib2bit for file access.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
  };
}
