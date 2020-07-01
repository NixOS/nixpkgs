{ buildPythonApplication, fetchPypi, lib
, youtube-dl
, PyChromecast
, click
, ifaddr
, requests
}:

buildPythonApplication rec {
  pname = "catt";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vq1wg79b7855za6v6bsfgypm0v3b4wakap4rash45mhzbgjj0kq";
  };

  propagatedBuildInputs = [
    youtube-dl PyChromecast click ifaddr requests
  ];

  doCheck = false; # attempts to access various URLs

  meta = with lib; {
    description = "Cast All The Things allows you to send videos from many, many online sources to your Chromecast";
    homepage = "https://github.com/skorokithakis/catt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}

