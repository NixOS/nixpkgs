{ lib, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "catt";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fef58bf7a8ebaba98399d1077cc4615f53d0196aab2a989df369a66f7111963b";
  };

  propagatedBuildInputs = [
    click
    ifaddr
    PyChromecast
    requests
    youtube-dl
  ];

  doCheck = false; # attempts to access various URLs
  pythonImportsCheck = [ "catt" ];

  meta = with lib; {
    description = "Cast All The Things allows you to send videos from many, many online sources to your Chromecast";
    homepage = "https://github.com/skorokithakis/catt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}

