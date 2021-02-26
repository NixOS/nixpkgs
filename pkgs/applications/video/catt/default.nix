{ lib, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "catt";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6RUeinHhAvvSz38hHQP5/MXNiY00rCM8k2ONaFYbwPc=";
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

