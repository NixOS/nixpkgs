{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-ytmusic";
  version = "0.3.5";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-YTMusic";
    sha256 = "0pncyxfqxvznb9y4ksndbny1yf5mxh4089ak0yz86dp2qi5j99iv";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'ytmusicapi>=0.20.0,<0.21.0' 'ytmusicapi>=0.20.0'
  '';

  propagatedBuildInputs = [
    mopidy
    python3Packages.ytmusicapi
    python3Packages.pytube
  ];

  pythonImportsCheck = [ "mopidy_ytmusic" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Mopidy extension for playing music from YouTube Music";
    homepage = "https://github.com/OzymandiasTheGreat/mopidy-ytmusic";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}
