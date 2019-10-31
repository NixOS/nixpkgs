{ buildPythonApplication, fetchPypi, lib
, youtube-dl
, PyChromecast
, click
, ifaddr
, requests
}:

buildPythonApplication rec {
  pname = "catt";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n6aa2vvbq0z3vcg4cylhpqxch783cxvxk234647knklgg9vdf1r";
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

