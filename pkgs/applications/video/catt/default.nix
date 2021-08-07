{ lib, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "catt";
  version = "0.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BOETKTkcbLOu5SubiejswU7D47qWS13QZ7rU9x3jf5Y=";
  };

  propagatedBuildInputs = [
    click
    ifaddr
    PyChromecast
    requests
    youtube-dl
  ];

  # remove click when 0.12.3 is released
  # upstream doesn't use zeroconf directly but pins it for pychromecast
  postPatch = ''
    substituteInPlace setup.py \
      --replace "zeroconf==0.31.0" "" \
      --replace "Click>=7.1.2,<8" "click"
  '';

  doCheck = false; # attempts to access various URLs
  pythonImportsCheck = [ "catt" ];

  meta = with lib; {
    description = "Cast All The Things allows you to send videos from many, many online sources to your Chromecast";
    homepage = "https://github.com/skorokithakis/catt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
