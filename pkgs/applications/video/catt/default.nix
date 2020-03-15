{ buildPythonApplication, fetchPypi, lib
, youtube-dl
, PyChromecast
, click
, ifaddr
, requests
}:

buildPythonApplication rec {
  pname = "catt";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08rjimcy9n7nvh4dz9693gjmkq6kaq5pq1nmjjsdrb7vb89yl53i";
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

